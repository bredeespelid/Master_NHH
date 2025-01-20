
# Task_1 ------------------------------------------------------------------
#a

# Data
x <- c(1, 2, 3, 4, 5)
y <- c(1.88, 4.54, 10.12, 9.14, 11.26)

# Compute coefficients manually
n <- length(x)
x_mean <- mean(x)
y_mean <- mean(y)

beta1 <- (n * sum(x * y) - sum(x) * sum(y)) / (n * sum(x^2) - sum(x)^2)
beta0 <- y_mean - beta1 * x_mean

# Prediction for x = 3
x0 <- 3
f_hat <- beta0 + beta1 * x0
f_hat

#b

# Fit the linear model
model <- lm(y ~ x)

# Predict for x = 3
predict(model, newdata = data.frame(x = 3))

#c

# Define a custom KNN function
knn <- function(x0, x, y, K) {
  d <- abs(x - x0)           # Calculate absolute differences
  o <- order(d)[1:K]         # Find indices of K closest points
  ypred <- mean(y[o])        # Average of K nearest y-values
  return(ypred)
}

# Predictions for different values of K
knn(x0 = 3, x = x, y = y, K = 1)
knn(x0 = 3, x = x, y = y, K = 3)
knn(x0 = 3, x = x, y = y, K = 5)


#d

K <- 3
x0 <- 3
x <- 1:5
y <- c(1.88, 4.54, 10.12, 9.14, 11.26)

# Step 1: Calculate absolute differences
d <- abs(x - x0)
d  # Output: [1] 2 1 0 1 2

# Step 2: Order indices based on smallest distances
o <- order(d)[1:K]
o  # Output: Indices of the 3 closest points

# Step 3: Average the y-values of the closest points
ypred <- mean(y[o])
ypred


#e

# Plot the data
plot(x, y, main = "Scatterplot of x and y with KNN vs Linear Regression",
     xlab = "x", ylab = "y", pch = 19, col = "blue")
abline(lm(y ~ x), col = "red", lwd = 2) # Add linear regression line

# Add predictions for KNN
points(3, knn(x0 = 3, x = x, y = y, K = 1), col = "green", pch = 16)
points(3, knn(x0 = 3, x = x, y = y, K = 3), col = "purple", pch = 16)
points(3, knn(x0 = 3, x = x, y = y, K = 5), col = "orange", pch = 16)
legend("topright", legend = c("Linear Regression", "KNN (K=1)", "KNN (K=3)", "KNN (K=5)"),
       col = c("red", "green", "purple", "orange"), pch = 16)



# Task_2 ------------------------------------------------------------------


# Load necessary package
library(ISLR)

# Summarize the College dataset
summary(College)

#b
set.seed(123)  # Set seed for reproducibility
n <- nrow(College)
train_indicator <- sample(1:n, size = floor(n / 2))  # Randomly select 50% of the data
train <- College[train_indicator, ]  # Training data
test <- College[-train_indicator, ]  # Test data

#c
# Fit the linear model
m1 <- lm(Apps ~ Private + Accept, data = train)
summary(m1)  # Summarize the model

#d
# Predict on the training set
pred_train <- predict(m1)

# Calculate training-MSE
mse_train <- mean((train$Apps - pred_train)^2)
mse_train

#e

# Fit the model with only Accept
m2 <- lm(Apps ~ Accept, data = train)
summary(m2)

# Predict on the training set
pred_train_m2 <- predict(m2)

# Calculate training-MSE
mse_train_m2 <- mean((train$Apps - pred_train_m2)^2)
mse_train_m2

#f

# Test-MSE for model in c)
pred_test_m1 <- predict(m1, newdata = test)
mse_test_m1 <- mean((test$Apps - pred_test_m1)^2)

# Test-MSE for model in e)
pred_test_m2 <- predict(m2, newdata = test)
mse_test_m2 <- mean((test$Apps - pred_test_m2)^2)

mse_test_m1
mse_test_m2

#h

# Load required package
library(FNN)  # For knn.reg function

# Normalize predictors for KNN
normalize <- function(x) (x - min(x)) / (max(x) - min(x))
train_knn <- data.frame(
  Accept = normalize(train$Accept),
  Apps = train$Apps
)
test_knn <- data.frame(
  Accept = normalize(test$Accept),
  Apps = test$Apps
)

# Run KNN regression (K = 3 as an example)
k <- 3
knn_pred <- knn.reg(train = train_knn[, "Accept", drop = FALSE],
                    test = test_knn[, "Accept", drop = FALSE],
                    y = train_knn$Apps,
                    k = k)$pred

# Calculate test-MSE for KNN
mse_knn <- mean((test_knn$Apps - knn_pred)^2)
mse_knn



# Task_3 ------------------------------------------------------------------


library(ISLR)

# Load the dataset
data(Carseats)

# View summary
summary(Carseats)

#a

# Fit a multiple regression model
model_a <- lm(Sales ~ Price + Urban + US, data = Carseats)
summary(model_a)

#e

# Fit a smaller model
model_e <- lm(Sales ~ Price + US, data = Carseats)
summary(model_e)

#f

summary(model_a)$r.squared
summary(model_a)$adj.r.squared

summary(model_e)$r.squared
summary(model_e)$adj.r.squared


