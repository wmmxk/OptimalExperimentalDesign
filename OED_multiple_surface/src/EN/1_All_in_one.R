source("../setpath.R")

library(mlegp)

args = commandArgs(TRUE)
add = as.integer(args[1])
iter_num = as.integer(args[2])
pool_size = as.integer(args[3])
repeat_time = as.integer(args[4])
set_name = args[5]
noise_level = as.integer(args[6]) # how much noise to add when generating the data
anti_pool = args[7]  # anti_pool means anti_batch
measure = args[8]

# add = 3
# iter_num = 10
# pool_size = 500 
# repeat_time = 1
# set_name = "real"
# noise_level = 2
# anti_pool = "true"
# measure = "relative"

# used to get the range of output
all_surface = read.csv(file.path(data_path,"surface_real.csv"), header=TRUE)
std = mean(all_surface[,3]) * noise_level/100


data_all= as.matrix(read.csv(file.path(out_data_path,"train_pool",paste(repeat_time,set_name,"noise",noise_level,sep=""),"GPsynthetic1.csv"), header=TRUE))
#pool dataset
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
  #select datapoints in a batch
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
      
      #predict on the pool
      
      res =  predict_benchmark(inverse,d,beta,sigma, mu, nugget, nubmer,fitZ,df,data,unfold=TRUE, measure = measure) 
      pred = res[1:length(res)/2]
      var = res[(length(res)/2+1):length(res)]
      index=sort(var, decreasing = TRUE,index.return=TRUE)$ix
      
      if (times > 1) {
        adddata=data[index[1],1:3,drop=FALSE]
        
        # the truth for the singal datapoint selected
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
      
      # remove the selected data 
      total=1:dim(data)[1]
      remove=index[1:add]
      left=total[!total%in%remove]
      lefttrain=data[left,]
      
      # update the pool by appending another batch to the pool
      if (times > 1) {
      data = rbind(lefttrain,data_all[pool_size+(p-1)*add + time,])
      } else {
      data = rbind(lefttrain,data_all[(pool_size+(p-1)*add+1):(pool_size+p*add),])
      }
  }
  # if add is larger than 1 and anti_poo is true, replace the prediction with the true.
  if (times > 1) {
    # add noise to the truth
    truth_for_select = truth_for_select + rnorm(length(truth_for_select),0,std)
    train[(nrow(train)-add*5+1):nrow(train),3] = truth_for_select
  }
  #test the prediction on benchmark set
  # dat is the benchmark set
  errors[p] =  predict_benchmark(inverse,d,beta,sigma, mu, nugget, nubmer,fitZ,df,dat,measure = measure)
  
}

time=proc.time() -ptm
cat("time",time)
write.csv(errors,file=file.path(out_data_path,paste("errors",repeat_time,set_name,"noise",noise_level,"anti_pool_",anti_pool,"measure_",measure,sep=""),"EN",paste("every_",add,"_",iter_num,"_iter.csv",sep="")))
write.csv(train,file=file.path(out_data_path,paste("errors",repeat_time,set_name,"noise",noise_level,"anti_pool_",anti_pool,"measure_",measure,sep=""),"EN",paste("train_every_",add,"_",iter_num,"_iter.csv",sep="")))


