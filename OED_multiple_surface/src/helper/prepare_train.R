prepare_train <- function (file_path,random_seed,start_size,noise_level,pool_size = 500) {
 
  data_all = read.csv(file_path, header=TRUE)
  #shuffle rows before splitting into train, pool_all and benchmark
  set.seed(random_seed)
  data_all = as.matrix(data_all[sample(nrow(data_all)),])
  
  std = noise_level*0.01

  train = data_all[1:start_size,]
  
  if (noise_level>0) {
    train = rbind(train,train)
    train[,3] = train[,3] + rnorm(nrow(train), sd=train[,3]*noise_level*0.01)
  }
  
  pool = data_all[(start_size+1):(start_size+pool_size),]
  pool_all = data_all[(start_size+pool_size+1):(start_size+1300),]


  benchmark = data_all[(start_size+1301):nrow(data_all),]
  
  res = list("train" = train, "pool" = pool, "pool_all" = pool_all,"benchmark"=benchmark)
  return(res)
}
