n <- 100

set.seed(123)
x <- rnorm(n)

plot(density(x))

eps <- rnorm(n)

#b

#Generate y = 1 + x + 0.5x^2 + 0.5 x^3 + eps 
y <- 1 + x - 0.5*x^2 + 0.5*x^3 + eps 

head(cbind(x,eps,y))

lm(y ~ x+I(x^2)+I(x^3))

# Best subset selection
library(leaps)

XY <- data.frame(matrix(0,n,11))

for(j in 1:10){
  
  XY[, j] <- x^j
  colnames(XY)[j] <- paste("x",j, sep = "")
}