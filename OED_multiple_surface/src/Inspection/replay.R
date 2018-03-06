source("../setpath.R")

library(mlegp)

# args = commandArgs(TRUE)
# set_id = args[1]
# noise_level = as.integer(args[2])
# random_seed = as.integer(args[3])
# method = args[4]
# 
# add = as.integer(args[5])
# iter_num = as.integer(args[6])

set_id = 2
noise_level = 0
random_seed = 1
method = "EN"
iter_num = 180
add = 1


pool_size = 650
start_size = 50

folder = paste("data_",set_id,"_noise_",noise_level,"_seed_",random_seed,sep = "")
train_name = "train_every_1_iter_180.csv"
error_name = "every_1_iter_180.csv"
train = read.csv(file.path(out_data_path,folder,method,train_name))[,2:4]
train = as.matrix(train)
errors_selected = read.csv(file.path(out_data_path,folder,method,error_name))

file_path = file.path(data_path,paste(set_id,".csv",sep=""))
Rcodes = c("prepare_train.R","compute_kernel.R","predict_benchmark.R",
           "update_train_pool.R","save_res.R","screen_index.R",
           "train_GP.R","max_dist.R","compute_MI_denominator.R")
for (Rcode in Rcodes) {
  source(file.path(helper_path,Rcode))
}

data = prepare_train(file_path,random_seed,start_size,noise_level)
benchmark = data$benchmark
errors = as.numeric()


p = 133

end = start_size+p*add
fit =  mlegp(train[1:end,1:2],train[1:end,3])

error =  predict_benchmark(fit,train[1:end,],benchmark,unfold=FALSE) 
cat("error",error)
p = p+1
cat("end :",end)


pred = predict(fit, benchmark[1:10,1:2], se.fit=TRUE)




# 

