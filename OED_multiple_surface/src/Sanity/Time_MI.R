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

for (repeat in 1:3)
{
times_tr = as.numeric()
times_en = as.numeric()
times_mi = as.numeric()
train_size = as.numeric()

res = NULL

for (start_size in seq(50,90,30)) {
    data = prepare_train(file_path,random_seed,start_size,noise_level,pool_size = 600)
    train = data$train
    pool = data$pool

    train_size = c(train_size,nrow(train))

    ptm <- proc.time() 
    model_tr = train_GP(train,add)
    fit = model_tr$model
    train = model_tr$train
    
    ptm1 <- proc.time() 
    a = ptm1 - ptm
    times_tr = c(times_tr, a[2])
    
    errors[p] =  predict_benchmark(fit,train,benchmark,unfold=FALSE) 
    
    ptm2 <- proc.time() 
    select_index = screen_index(fit,train,pool,add,method)# This part is different for different OED method
    ptm3 <- proc.time() 
    b = ptm3 - ptm2
    times_mi = c(times_mi,b[3])
    
    ptm4 <- proc.time() 
    select_index = screen_index(fit,train,pool,add,"EN")# This part is different for different OED method
    ptm5 <- proc.time() 
    c = ptm5 - ptm4
    times_en = c(times_en,c[3])
}
res = rbind(times_tr,times_en,times_mi)
}
res = rbind(train_size,res)

