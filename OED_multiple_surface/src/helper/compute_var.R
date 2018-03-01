predict_benchmark <- function (inverse,d,beta,sigma, mu, nugget, nubmer,fitZ,df,data,debug=FALSE) {
# inverse=fit$invVarMatrix
# d=fit[["numDim"]]
# beta=fit[["beta"]]
# sigma=fit[["sig2"]]
# mu=fit[["mu"]]
# nugget=fit[["nugget"]]
# number=fit[["numObs"]]
# fitZ = fit$Z
# df=as.matrix(train)
    newcov=matrix(nrow=dim(data)[1],ncol=number)
    for ( i in 1:dim(data)[1]) {
      j=1
      for (j in 1:number) {
        k=1
        dist=0
        for (k in 1:d)
          dist=dist-(data[i,k]-df[j,k])^2*beta[k]
        newcov[i,j]=sigma*exp(dist)
      }
    }
    diag(newcov)=diag(newcov)+nugget 
    mean=newcov%*%inverse%*%(fitZ - mu)+mu[1]
    real=data[,3]
    var=diag(sigma+nugget-newcov%*%inverse%*%t(newcov))
    
    MAE = mean(abs(mean-real))
    
    # if not debug return the error only; if debug return the mean and var in one vector
    if (!debug) {
      return(MAE/(max(real)-min(real)))
    } else { return(c(mean,var))}

}
