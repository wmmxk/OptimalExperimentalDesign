require(MASS)
m <- matrix(rnorm(1e4),nrow=1e2,ncol=1e2)

#compute the covariance
mat <- cov(m)
cat("Determinant of the mat", det(t(m)%*%m))

cat("Determinant of the mat", det(mat))


#compute condition number: 
#And, since it is much larger than 1e+16, the matrix is clearly singular
kappa(mat)
