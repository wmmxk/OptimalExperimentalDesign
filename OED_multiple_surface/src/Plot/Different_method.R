source("../setpath.R")

EN= read.csv(file.path(out_data_path,"error_no_train/errors_1","EN","every_1_120_iter.csv"), header=TRUE)


MI= read.csv(file.path(out_data_path,"error_no_train/errors_1","MI","every_1_120_iter.csv"), header=TRUE)


Random= read.csv(file.path(out_data_path,"error_no_train/errors_1","Random","every_1_120_iter.csv"), header=TRUE)


n = 100
size = 1.3
errors = matrix(nrow=n,ncol=3)

errors[,1] = EN[1:n,2]
errors[,2] = MI[1:n,2]
errors[,3] = Random[1:n,2]

par(fig = c(0,1,0,1))
# par(mar=c(6,6,4,4))
# pdf(file.path(out_fig_path,"error_syn.pdf"))

plot(seq(1,n,1), errors[,1]*100, col=4,type='l',ylim=c(0,max(errors)*100),xlab="# of samples",
     ylab="MAE (%)",cex.lab = size,cex.axis = size)

for (i in 2:3) {
  lines(seq(1,n,1), errors[,i]*100, col=i)
  
}

legend("topright",xpd=TRUE, legend=c("Random","EN","MI"),bty="n",
       col=c(3,4,2),lty=c(1,1,1),cex=size*0.7)


size = size*0.8
# insert a zoom in plot
par(fig = c(0.3,0.9,0.3,0.88),new=T)
plot(seq(1,n,1), errors[,1]*100, col=4,type='l',ylim=c(0,6),xlim=c(60,100),xlab="# of samples",
     ylab="MAE (%)",cex.lab = size,cex.axis = size)

for (i in 2:3) {
  lines(seq(1,n,1), errors[,i]*100, col=i)
  
}

dev.off()