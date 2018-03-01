
predict_benchmark <- function (fit,train,benchmark,unfold=FALSE) {
  
  
    d=fit[["numDim"]]
    beta=fit[["beta"]]
    sigma=fit[["sig2"]]
    
    inverse=fit$invVarMatrix
    mu=fit[["mu"]]
    fitZ = fit$Z
    nugget=fit[["nugget"]]
  
    newcov = compute_kernel(d,beta,sigma, train,benchmark)
      
    diag(newcov)=diag(newcov) #+nugget 
    mean=newcov%*%inverse%*%(fitZ - mu)+mu[1]
    real=benchmark[,3]
    var=diag(sigma+nugget-newcov%*%inverse%*%t(newcov))
    
    mean_var = list("mean"=mean,"var"=var)
    MAE = mean(abs(mean-real))
    
    # if not debug return the error only; if debug return the mean and var in one vector
    if (unfold) {
      return(mean_var)
    } else { 
      return(MAE)
     }
}
