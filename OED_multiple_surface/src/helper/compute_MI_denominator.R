compute_MI_denominator <- function (fit,pool) {
  
  d=fit[["numDim"]]
  beta=fit[["beta"]]
  sigma=fit[["sig2"]]
  nugget=fit[["nugget"]]
  
  ## cov(unob, unob)
  cov_unob = compute_kernel(d,beta,sigma, pool,pool)
  diag(cov_unob)=diag(cov_unob)+nugget+sigma
  # compute denominator for each point in pool
  divisor= as.numeric()
  for (i in 1:nrow(pool)) {
    invers_bar = chol2inv(chol(cov_unob[-i,-i]))
    divisor[i] =  sigma+nugget - cov_unob[i,-i,drop=FALSE] %*% invers_bar %*% t(cov_unob[i,-i,drop=FALSE])
  }
  
  return(divisor)
}