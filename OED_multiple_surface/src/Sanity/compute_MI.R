source("../setpath.R")
require(MASS)
library(mlegp)

args = commandArgs(TRUE)
add = as.integer(args[1])
iter_num = as.integer(args[2])
pool_size = as.integer(args[3])

pool_size = 500

data= as.matrix(read.csv(file.path(out_data_path,"GPsynthetic1.csv"), header=TRUE))[1:pool_size,]

train= read.csv(file.path(out_data_path,"entropy_train.csv"), header=TRUE)

ptm <- proc.time()  

xx=as.matrix(train[,1:2])
y=as.matrix(train[,3])

fit=mlegp(xx,y)
#fit=mlegp(xx,y,nugget=1,nugget.known=1)

inverse=fit$invVarMatrix


d=fit[["numDim"]]
beta=fit[["beta"]]
sigma=fit[["sig2"]]
mu=fit[["mu"]]
nugget=fit[["nugget"]]
number=fit[["numObs"]]

df=as.matrix(train)


# compute the variance y/A
newcov=matrix(nrow=dim(data)[1],ncol=number)

for ( i in 1:dim(data)[1]) {
  j=1
  for (j in 1:number) {
    k=1
    dist=0
    for (k in 1:d) {
      dist=dist-(data[i,k]-df[j,k])^2*beta[k]
    }
    newcov[i,j]=sigma*exp(dist)
  }
}

diag(newcov)=diag(newcov)+nugget
mean=newcov%*%inverse%*%(fit$Z - fit$mu)+mu[1]
var=diag(sigma+nugget-newcov%*%inverse%*%t(newcov))

# compute the variance y/(A bar)
  # cov(A_bar, A_bar)
cov_unob =matrix(nrow=nrow(data),ncol=nrow(data))

for ( i in 1:nrow(data))
{
  j=1
  for (j in 1:nrow(data)) {
    k=1
    dist=0
    for (k in 1:d) {
      dist=dist-(data[i,k]-data[j,k])^2*beta[k]
    }
    cov_unob[i,j]=sigma*exp(dist)
  }
}
diag(cov_unob)=diag(cov_unob) +  sigma + nugget


cat("Determinant of the cov", det(cov_unob))
kappa(cov_unob)


inv1 = solve(cov_unob)
inv2 = chol2inv(chol(cov_unob))

plot(as.vector(inv1), as.vector(inv2))

ptm <- proc.time()  
# compute denominator
divisor= as.numeric()
for (i in 1:nrow(data)) {
# invers_bar = solve(cov_unob[-i,-i])
  
  invers_bar = chol2inv(chol(cov_unob[-i,-i]))
  
  divisor[i] =  sigma+nugget - cov_unob[i,-i,drop=FALSE] %*% invers_bar %*% t(cov_unob[i,-i,drop=FALSE])
  
}


proc.time()  - ptm







