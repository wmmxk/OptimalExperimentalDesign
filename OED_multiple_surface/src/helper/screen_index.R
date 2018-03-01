screen_index <- function (fit,train,pool,add,method) {
  if (method=="EN" || method=="MI"){
  res =  predict_benchmark(fit,train,pool,unfold=TRUE) 
  var = res$var
  }
  
  if (method=="EN")
  {
  index=sort(var, decreasing = TRUE,index.return=TRUE)$ix
  select = c(index[1:2],1)
  return(select)
  }
  
  if (method=="Random") {
    return(seq(1,add,1))
  }
  
  if (method== "MI") {
    divisor = compute_MI_denominator(fit,pool) 
    index=sort(var/divisor, decreasing = TRUE,index.return=TRUE)$ix
    select = c(index[1:2],1)
    return(select)
  }
}
