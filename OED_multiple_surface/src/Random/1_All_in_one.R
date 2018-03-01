source("../setpath.R")

library(mlegp)

args = commandArgs(TRUE)
add = as.integer(args[1])
iter_num = as.integer(args[2])
pool_size = as.integer(args[3])
repeat_time = as.integer(args[4])
set_name = args[5]
noise_level = args[6]
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

xx=as.matrix(train[,1:2])
y=as.matrix(train[,3])

fit=mlegp(xx,y)
inverse=fit$invVarMatrix

d=fit[["numDim"]]
beta=fit[["beta"]]
sigma=fit[["sig2"]]
mu=fit[["mu"]]
nugget=fit[["nugget"]]
number=fit[["numObs"]]
fitZ = fit$Z
df=as.matrix(train)


# select the top add rows and add them to train. (caveat: when indexing one row,keep the dimension)
adddata=data[1:add,1:3,drop=FALSE]


without_noise = adddata[,3]
for (dup in 1:5) {
  noises = rnorm(nrow(adddata),0,std)
  adddata[,3] = without_noise + noises
  train=t(data.frame(t(train),t(adddata)))
}

index = seq(1,nrow(data),1)

total=1:dim(data)[1]
remove=index[1:add]
left=total[!total%in%remove]
lefttrain=data[left,]

# update the pool 
data = lefttrain

#test the prediction on benchmark set
# df is the train in current around
# dat is the benchmark set
errors[p] =  predict_benchmark(inverse,d,beta,sigma, mu, nugget, nubmer,fitZ,df,dat,measure = measure) 

}

time=proc.time() -ptm

write.csv(errors,file=file.path(out_data_path,paste("errors",repeat_time,set_name,"noise",noise_level,"anti_pool_",anti_pool,"measure_",measure,sep=""),"Random",paste("every_",add,"_",iter_num,"_iter.csv",sep="")))
write.csv(train,file=file.path(out_data_path,paste("errors",repeat_time,set_name,"noise",noise_level,"anti_pool_",anti_pool,"measure_",measure,sep=""),"Random",paste("train_every_",add,"_",iter_num,"_iter.csv",sep="")))

# 

