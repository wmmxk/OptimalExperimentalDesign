source("../setpath.R")

library(mlegp)

set_name = 3
start_size = 450

data_all = read.csv(file.path(data_path,paste(set_name,".csv",sep="")), header=TRUE)
data_all = as.matrix(data_all[sample(nrow(data_all)),])
std = noise_level*0.01

train = data_all[1:start_size,]
#train = rbind(train,train,train)
#train[,3] = train[,3] + rnorm(nrow(train),sd=0.09)

data = data_all[(start_size+1):(start_size+3000),]

xx= train[,1:2]
y= train[,3]

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

mean(abs(real-mean))
