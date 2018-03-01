source("../setpath.R")

library(mlegp)

args = commandArgs(TRUE)
add = as.integer(args[1])
iter_num = as.integer(args[2])


data= as.matrix(read.csv(file.path(out_data_path,"GPsynthetic1.csv"), header=TRUE))

train= read.csv(file.path(out_data_path,"entropy_train.csv"), header=TRUE)

# bencharmark set
dat= as.matrix(read.csv(file.path(out_data_path,"GPsynthetic2.csv"), header=TRUE))

# hold the prediction by each bootstrapping dataset
Bootstrap_time = 12



errors = as.numeric()

ptm <- proc.time()  
for (p in 1:iter_num){
means = matrix(nrow= nrow(data), ncol= Bootstrap_time)
for (Bootstrap in 1:Bootstrap_time) {
  # select 90% from the train
  select = sample(seq(1,nrow(train),1),ceiling(nrow(train)*0.9),replace = FALSE)
    
  xx=as.matrix(train[select,1:2])
  y=as.matrix(train[select,3])
  
  fit=mlegp(xx,y)
  #fit=mlegp(xx,y,nugget=1,nugget.known=1)
  
  inverse=fit$invVarMatrix
  
  
  d=fit[["numDim"]]
  beta=fit[["beta"]]
  sigma=fit[["sig2"]]
  mu=fit[["mu"]]
  nugget=fit[["nugget"]]
  number=fit[["numObs"]]
  
  df=as.matrix(train[select,])
  
  newcov=matrix(nrow=dim(data)[1],ncol=number)
  
  for ( i in 1:dim(data)[1]) {
    j=1
    for (j in 1:number) {
      k=1
      dist=0
      for (k in 1:d) {
        dist=dist-(data[i,k]-df[j,k])^2*beta[k]
      }
      newcov[i,j]=sigma*exp(dist)
    }
  }
  diag(newcov)=diag(newcov)+nugget
  
  mean=newcov%*%inverse%*%(fit$Z - fit$mu)+mu[1]
  means[,Bootstrap] = mean
}

mean_var=apply(means,1,var)
index=sort(mean_var, decreasing = TRUE,index.return=TRUE)$ix

adddata=data[index[1:add],1:3]
train=t(data.frame(t(train),t(adddata)))


total=1:dim(data)[1]
remove=index[1:add]
left=total[!total%in%remove]
lefttrain=data[left,]

# update the pool 
data = lefttrain


#test the prediction on benchmark set
# df is the train in current around
# dat is the benchmark set


newcov=matrix(nrow=dim(dat)[1],ncol=number)

i=1
for ( i in 1:dim(dat)[1]) {
  j=1
  for (j in 1:number) {
    k=1
    dist=0
    for (k in 1:d) {
      dist=dist-(dat[i,k]-df[j,k])^2*beta[k]
    }
    newcov[i,j]=sigma*exp(dist)
  }
}

diag(newcov)=diag(newcov)+nugget

mean=newcov%*%inverse%*%(fit$Z - fit$mu)+mu[1]
real=dat[,3]
var=diag(sigma+nugget-newcov%*%inverse%*%t(newcov))

errors[p] = mean(abs((mean-real)/real))


}

time=proc.time() -ptm


cat("time",time)
write.csv(errors,file=file.path(out_data_path,"errors","CI",paste("every_",add,"_",iter_num,"_iter.csv",sep="")))

