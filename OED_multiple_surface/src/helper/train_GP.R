train_GP <- function (train,add) {
  #if the last added datapoints causes a numerical issue, remove it.
  
  fit=mlegp(train[,1:2],train[,3])
  # if the new coming data causes a problem remove it.
  while (is.na(fit["sig2"])) {
    to_remove = if (noise_level>0) add*2 else add
    train = train[1:(nrow(train)-to_remove),]
    fit=mlegp(train[,1:2],train[,3])
  }
  res = list("model"=fit, "train" = train)
  return(res)
}
