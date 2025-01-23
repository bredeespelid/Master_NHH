library(ISLR2)
library(tidyverse)

plot.ts(Weekly$Today)
acf(Weekly$Today)
head(Weekly)

xdata <- as_tibble(Weekly)

xdata %>% 
  group_by(Direction) %>% 
  summarise_all(mean)


plot(Volume ~ Direction, data = Weekly)

#b 

formula1 <- Direction~Lag1+Lag2+Lag3+Lag4+Lag5

logreg <- glm(formula1, data = Weekly, family = "binomial")
summary(logreg)

#c

pred1 <- predict(logreg)

head(pred1)

pred2 <- predict(logreg, type "response")
