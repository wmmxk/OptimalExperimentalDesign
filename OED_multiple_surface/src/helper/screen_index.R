screen_index <- function (fit,train,pool,add,method) {
  if (method=="EN" || method=="MI"){
      res =  predict_benchmark(fit,train,pool,unfold=TRUE) 
      var = res$var
      if (method == "MI") {
        divisor = compute_MI_denominator(fit,pool) 
        index=sort(var/divisor, decreasing = TRUE,index.return=TRUE)$ix 
      } else {
        index=sort(var, decreasing = TRUE,index.return=TRUE)$ix
      }
  } else {index = seq(1,nrow(pool),1)}
  
  return(max_dist(add,index,pool))

}
