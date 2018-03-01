source("../setpath.R")

library(mlegp)

# args = commandArgs(TRUE)
# add = as.integer(args[1])
# iter_num = as.integer(args[2])
# pool_size = as.integer(args[3])
# repeat_time = as.integer(args[4])
# set_name = args[5]
# noise_level = args[6]
# anti_pool = args[7]
# measure = args[8]
add = 1
iter_num = 2
pool_size = 500
random_seed= 1
set_name = 1
noise_level = 5
start_size = 50

file_path = file.path(data_path,paste(set_name,".csv",sep=""))

Rcodes = c("prepare_train.R","compute_kernel.R","predict_benchmark.R","update_train_pool.R")
for (Rcode in Rcodes) {
  source(file.path(helper_path,Rcode))
}

data = prepare_train(file_path,random_seed,start_size,noise_level,pool_size)
train = data$train
pool = data$pool
pool_all = data$pool_all
benchmark = data$benchmark


errors = as.numeric()

ptm <- proc.time()  


for (p in 1:(iter_num+1))
{

xx= train[,1:2]
y= train[,3]
fit=mlegp(xx,y)

errors[p] =  predict_benchmark(fit,train,benchmark,unfold=FALSE) 

select_index = seq(1,add,1) # This part is different for different OED method

res = update_train_pool(select_index,train,pool,pool_all,noise_level)
train = res$train
pool = res$pool
pool_all = res$pool_all

}

time=proc.time() -ptm
cat(time)

error_file_name = paste("every_",add,"_iter_",iter_num,".csv",sep="")
train_file_name = paste("train_every_",add,"_iter_",iter_num,".csv",sep="")
folder = paste("data_",set_name,"_noise_",noise_level,"_seed_",random_seed,sep="")

nums = start_size + seq(0,iter_num,1)*add

errors = data.frame(nums,errors)


write.csv(errors,file=file.path(out_data_path,folder,"Random",error_file_name))
write.csv(train,file=file.path(out_data_path,folder,"Random",train_file_name))
# 

