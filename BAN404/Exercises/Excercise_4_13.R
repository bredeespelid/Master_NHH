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
