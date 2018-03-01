compute_kernel <- function (d,beta,sigma, train,benchmark) {
 
    number = nrow(train) 
    newcov=matrix(nrow=dim(benchmark)[1],ncol=number)
    for ( i in 1:dim(benchmark)[1]) {
      j=1
      for (j in 1:number) {
        k=1
        dist=0
        for (k in 1:d)
          dist=dist-(benchmark[i,k]-train[j,k])^2*beta[k]
        newcov[i,j]=sigma*exp(dist)
      }
    }
    return(newcov)
}
