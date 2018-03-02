source("../setpath.R")

library(mlegp)

# args = commandArgs(TRUE)
# add = as.integer(args[1])
# iter_num = as.integer(args[2])
# pool_size = as.integer(args[3])
# start_size = as.integer(args[4])
# 
# random_seed = as.integer(args[5])
# set_name = args[6]
# noise_level = as.integer(args[7])
# method = args[8]

method = "MI"
add = 3
iter_num = 60
pool_size = 500
start_size = 50
random_seed= 1
set_name = 1
noise_level = 0


file_path = file.path(data_path,paste(set_name,".csv",sep=""))

Rcodes = c("prepare_train.R","compute_kernel.R","predict_benchmark.R",
           "update_train_pool.R","save_res.R","screen_index.R",
           "train_GP.R","max_dist.R","compute_MI_denominator.R")
for (Rcode in Rcodes) {
  source(file.path(helper_path,Rcode))
}

data = prepare_train(file_path,random_seed,start_size,noise_level)
train = data$train
pool = data$pool
pool_all = data$pool_all
benchmark = data$benchmark

train_bad = train

errors = as.numeric()

ptm <- proc.time()  


for (p in 1:(iter_num+1))
{
  
cat("iteration: ",p-1, "\n")
cat(" Before train size", nrow(train_bad),"\n")
  
model_tr = train_GP(train)
fit = model_tr$model
train = model_tr$train


cat("iteration: ",p-1,"\n")
cat("train size", nrow(train_bad),"\n")

errors[p] =  predict_benchmark(fit,train,benchmark,unfold=FALSE) 
select_index = screen_index(fit,train,pool,add,method)# This part is different for different OED method


res = update_train_pool(select_index,train,train_bad,pool,pool_all,noise_level)
train = res$train
pool = res$pool
pool_all = res$pool_all
train_bad = res$train_bad

}

save_res(out_data_path,set_name,noise_level,random_seed,add,iter_num,errors,train_bad,method)


# 

