library(ISLR2)
head(Boston)

# a -----------------------------------------------------------------------
mu_hatt <- median(Boston$medv)
mu_hatt

# b -----------------------------------------------------------------------
n<- length(Boston$medv)
s<- sd(Boston$medv)
se_mu_hat <- s / sqrt(n)
se_mu_hat

# c -----------------------------------------------------------------------
library(boot)
# Define the function to compute mean
boot_mean <- function(data, indices) {
  return(mean(data[indices]))
}
# Perform bootstrap with 1000 resamples
boot_result <- boot(Boston$medv, boot_mean, R = 1000)
# Extract standard error from bootstrap
boot_se <- sd(boot_result$t)
boot_se

# d -----------------------------------------------------------------------
quantile(boot_result$t, probs = c(0.025, 0.975))
t.test(Boston$medv)







# boostrap_lecture --------------------------------------------------------
B <- 1000
mboot <- matrix(0,B,1)
for(b in 1:B){
  indboot <- sample(1:n, size=n,replace = T)
  xboot <- Boston$medv[indboot]
  mboot[b] <- mean(xboot)
}
head(mboot)
se_boot<- sd(mboot)
