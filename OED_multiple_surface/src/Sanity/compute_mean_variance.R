source("../setpath.R")

library(mlegp)

data= as.matrix(read.csv(file.path(out_data_path,"sanity","GPsynthetic1.csv"), header=TRUE))[1:100,]

train= read.csv(file.path(out_data_path,"sanity","entropy_train.csv"), header=TRUE)

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
fitZ = fit$Z
df=as.matrix(train)


source(file.path(helper_path,"predict_benchmark.R"))

res = predict_benchmark(inverse,d,beta,sigma, mu, nugget, nubmer,fitZ,df,data,unfold=TRUE) 
mean = res[1:(length(res)/2)]
var = res[(length(res)/2+1):length(res)]


real=data[,3]



# This is the predicted mean and variance by the interface coming with the package
pred = predict(fit, data[,1:2], se.fit=TRUE)
mean_pred = pred$fit
var_pred = (pred$se.fit)^2

plot(var_pred,var)

plot(mean_pred, mean)

plot(real, mean)
plot(real, mean_pred)
