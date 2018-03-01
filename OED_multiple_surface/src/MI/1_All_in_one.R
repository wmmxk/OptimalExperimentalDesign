source("../setpath.R")
require(MASS)
library(mlegp)

args = commandArgs(TRUE)
add = as.integer(args[1])
iter_num = as.integer(args[2])
pool_size = as.integer(args[3])
repeat_time = as.integer(args[4])
set_name = args[5]
noise_level = as.integer(args[6]) # how much noise to add when generating the data
anti_pool = args[7]
measure = args[8]




# used to get the range of output
all_surface = read.csv(file.path(data_path,"surface_real.csv"), header=TRUE)
std = mean(all_surface[,3]) * noise_level/100

data_all= as.matrix(read.csv(file.path(out_data_path,"train_pool",paste(repeat_time,set_name,"noise",noise_level,sep=""),"GPsynthetic1.csv"), header=TRUE))
data = data_all[1:pool_size,]
train= read.csv(file.path(out_data_path,"train_pool",paste(repeat_time,set_name,"noise",noise_level,sep=""), "entropy_train.csv"), header=TRUE)
# bencharmark set
dat= as.matrix(read.csv(file.path(out_data_path, "train_pool",paste(repeat_time,set_name,"noise",noise_level,sep=""),"GPsynthetic2.csv"), header=TRUE))

errors = as.numeric()

ptm <- proc.time()  
source(file.path(helper_path,"predict_benchmark.R"))
for (p in 1:iter_num)
{
  if (add> 1 && anti_pool =="true") {
    times = add  
  } else {times = 1}
  truth_for_select = as.numeric()
  
  for (time in 1:times)  
  {
      xx=as.matrix(train[,1:2])
      y=as.matrix(train[,3])
      
      fit=mlegp(xx,y)
      #fit=mlegp(xx,y,nugget=1,nugget.known=1)
      
      inverse=fit$invVarMatrix
      
      d=fit[["numDim"]]
      beta=fit[["beta"]]
      sigma=fit[["sig2"]]
      mu=fit[["mu"]]
      nugget=fit[["nugget"]]
      number=fit[["numObs"]]
      fitZ = fit$Z
      df=as.matrix(train)
      
      
      # compute the variance y/A
      res =  predict_benchmark(inverse,d,beta,sigma, mu, nugget, nubmer,fitZ,df,data,unfold=TRUE, measure = measure) 
      var = res[(length(res)/2+1):length(res)]
      pred = res[1:length(res)/2]
      
      # compute the variance y/(A bar)
      # cov(A_bar, A_bar)
      cov_unob =matrix(nrow=nrow(data),ncol=nrow(data))
      
      for ( i in 1:nrow(data)) {
        j=1
        for (j in 1:nrow(data)) {
          k=1
          dist=0
          for (k in 1:d) {
            dist=dist-(data[i,k]-data[j,k])^2*beta[k]
          }
          cov_unob[i,j]=sigma*exp(dist)
        }
      }
      diag(cov_unob)=diag(cov_unob) +  sigma + nugget
      
      # compute denominator
      divisor= as.numeric()
      for (i in 1:nrow(data)) {
        # invers_bar = solve(cov_unob[-i,-i])
        invers_bar = chol2inv(chol(cov_unob[-i,-i]))
        divisor[i] =  sigma+nugget - cov_unob[i,-i,drop=FALSE] %*% invers_bar %*% t(cov_unob[i,-i,drop=FALSE])
        
      }
      
      index=sort(var/divisor, decreasing = TRUE,index.return=TRUE)$ix
      # select the top add rows and add them to train. (caveat: when indexing one row,keep the dimension)
      if (times > 1) {
        adddata=data[index[1],1:3,drop=FALSE]

        add_truth = c(adddata[1,3],adddata[1,3],adddata[1,3],adddata[1,3],adddata[1,3])
        truth_for_select = c(truth_for_select, add_truth) #five replicates
        adddata[1,3] = pred[index[1]]

      } else {  # if add>1 and anti_pool==FALSE, select the add data at once
        adddata=data[index[1:add],1:3,drop=FALSE]
      }
      
      #update the train dataset by adding 5 replicates for each data point
      without_noise = adddata[,3]
      for (dup in 1:5) {
      noises = rnorm(nrow(adddata),0,std)

      adddata[,3] = without_noise + noises
      train=t(data.frame(t(train),t(adddata)))
      }
      # update the index and remove the left data in the pool

      if (times > 1) {
         remove=index[1]
      } else {
        remove=index[1:add] 
      }
      total=1:dim(data)[1]
      left=total[!total%in%remove]
      leftpool = data[left,]
      
      # update the pool by appending another batch to the pool
      if (times > 1) {
        data = rbind(leftpool, data_all[pool_size+(p-1)*add + time,])
      } else {
        data = rbind(leftpool, data_all[(pool_size+(p-1)*add+1):(pool_size+p*add),])
      }
  }
  # after a batch is selected, replace the prediction with true values
  if (times > 1) {
    # add noise to the truth
    truth_for_select = truth_for_select + rnorm(length(truth_for_select),0,std)
    train[(nrow(train)-add*5+1):nrow(train),3] = truth_for_select
  }

#test the prediction on benchmark set
# dat is the benchmark set

errors[p] =  predict_benchmark(inverse,d,beta,sigma, mu, nugget, nubmer,fitZ,df,dat, measure = measure) 
}

time=proc.time() -ptm
cat("time",time)
write.csv(errors,file=file.path(out_data_path,paste("errors",repeat_time,set_name,"noise",noise_level,"anti_pool_",anti_pool,"measure_",measure,sep=""),"MI",paste("every_",add,"_",iter_num,"_iter.csv",sep="")))
write.csv(train,file=file.path(out_data_path,paste("errors",repeat_time,set_name,"noise",noise_level,"anti_pool_",anti_pool,"measure_",measure,sep=""),"MI",paste("train_every_",add,"_",iter_num,"_iter.csv",sep="")))


