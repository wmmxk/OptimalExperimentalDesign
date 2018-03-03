source("../setpath.R")

library(mlegp)


set_id = 4
noise_level = 1
random_seed = 1
method = "MI"
add = 2
iter_num = 30

pool_size = 650
start_size = 50


file_path = file.path(data_path,paste(set_id,".csv",sep=""))

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
times_tr = as.numeric()
times_mi = as.numeric()
 
for (i in 1:10){
    ptm <- proc.time() 
    model_tr = train_GP(train,add)
    fit = model_tr$model
    train = model_tr$train
    
    
    cat("iteration: ",p-1,"\n")
    cat("train size", nrow(train_bad),"\n")
    
    ptm1 <- proc.time() 
    a = ptm1 - ptm
    times_tr = c(times_tr, a[2])
    
    errors[p] =  predict_benchmark(fit,train,benchmark,unfold=FALSE) 
    
    ptm2 <- proc.time() 
    select_index = screen_index(fit,train,pool,add,method)# This part is different for different OED method
    
    ptm3 <- proc.time() 
    b = ptm3 - ptm2
    times_mi = c(times_mi,b[3])
    
    train = rbind(train,pool[(i*3):((i+1)*3-1),])

}