source("../setpath.R")

source(file.path(helper_path,"predict_benchmark.R"))

source(file.path(helper_path,"compute_kernel.R"))

library(mlegp)

set_name = 3
start_size = 50

data_all = read.csv(file.path(data_path,paste(set_name,".csv",sep="")), header=TRUE)
data_all = as.matrix(data_all[sample(nrow(data_all)),])
std = noise_level*0.01

train = data_all[1:start_size,]
benchmark = data_all[(start_size+1):(start_size+3000),]

xx=as.matrix(train[,1:2])
y=as.matrix(train[,3])

fit=mlegp(xx,y)

inverse=fit$invVarMatrix

d=fit[["numDim"]]
beta=fit[["beta"]]
sigma=fit[["sig2"]]
mu=fit[["mu"]]
nugget=fit[["nugget"]]
number=fit[["numObs"]]
fitZ = fit$Z
df=as.matrix(train)

covariance = compute_kernel(d,beta,sigma, train,train)
diag(covariance)=diag(covariance ) # no addition here: +  sigma + nugget

inverse = chol2inv(chol(covariance))

newcov = compute_kernel(d,beta,sigma, train,benchmark)

diag(newcov)=diag(newcov) #+nugget 

var=diag(sigma+nugget-newcov%*%inverse%*%t(newcov))


real=benchmark[,3]



# This is the predicted mean and variance by the interface coming with the package
pred = predict(fit, benchmark[,1:2], se.fit=TRUE)
mean_pred = pred$fit
var_pred = (pred$se.fit)^2

plot(var_pred,var)

plot(mean_pred, mean)

plot(real, mean)
plot(real, mean_pred)
