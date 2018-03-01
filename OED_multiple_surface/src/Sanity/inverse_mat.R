require(MASS)
m <- matrix(rnorm(1e4),nrow=1e2,ncol=1e2)

#compute the covariance
mat <- cov(m)
cat("Determinant of the mat", det(mat))

t0 <- proc.time()
inv0 <- ginv(mat)
proc.time() - t0 

t1 <- proc.time()
for (i in 1:10)
inv1 <- solve(mat)
proc.time() - t1 



#Consider inverting a symmetric positive defininite matrix.  An R approach to doing so is via a Cholesky decomposition
# This way is faster

t1 <- proc.time()
for (i in 1:10)
inv2 <- chol2inv(chol(mat))
proc.time() - t1 

plot(diag(inv1), diag(inv2))
