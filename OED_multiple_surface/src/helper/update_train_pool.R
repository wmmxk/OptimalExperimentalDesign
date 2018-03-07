update_train_pool <- function (select_index,train,train_bad,pool,pool_all,noise_level) {
 
  adddata=pool[select_index,1:3,drop=FALSE]
  # select the top add rows and add them to train. (caveat: when indexing one row,keep the dimension)
  
  
  if (noise_level > 0) {
        without_noise = adddata[,3]
        for (dup in 1:2) {
          noises = rnorm(nrow(adddata),0,without_noise*noise_level*0.01)
          adddata[,3] = without_noise + noises
          train=t(data.frame(t(train),t(adddata)))
          train_bad=t(data.frame(t(train_bad),t(adddata)))
        }
  } else {
    train=t(data.frame(t(train),t(adddata)))
    train_bad = t(data.frame(t(train_bad),t(adddata)))
  }
  
  pool = pool[-select_index,]
  
  # update the pool 
  pool = rbind(pool,pool_all[1:add,])
  pool_all = pool_all[(add+1):nrow(pool_all),]
  
  res = list("train" = train, "pool" = pool, "pool_all" = pool_all,"train_bad" = train_bad)
  return(res)
}
