library(ISLR2)
library(dplyr)
library(ggplot2)

#First look at the data
head(Auto)

str(Auto)

sapply(Auto, class)

plot(mpg~horsepower, data = Auto)
abline(a = 40.0, b = -0.16, col = "red")

library(tidyverse)

auto_tv <- as_tibble(Auto)

auto_tv %>% 
  ggplot()+
  geom_point(aes(x = horsepower, y = mpg))+
  theme_minimal() 
str(auto_tv)

# a

reg1 <- lm(mpg~horsepower, data = Auto)
summary(reg1)


reg1$coefficients

auto_tv %>% select(mpg, horsepower) %>% 
  lm() %>% summary()

auto_tv %>% select(mpg, horsepower) %>% 
  lm() %>% predict(tibble(horsepower = 98))

pred1 <- predict(reg1, newdata =  data.frame ( horsepower= 98))
pred1

# Using KNN

knn <- function(x0, x,y, K = 3){
  d<- abs(x-x0)
  o <- order(d)[1:K]
  ypred <- mean(y[o])
  return(ypred)
}

x0 <- 98
x <- Auto$horsepower
y <- Auto$mpg

knn(x0, x,y, K =3)

