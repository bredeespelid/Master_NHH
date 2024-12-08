# List of packages to install
packages <- c(
  "anytime", "countries", "DescTools", "doParallel", "dplyr", "forcats", "foreign", 
  "furrr", "gapminder", "ggplot2", "here", "httr", "jsonlite", "kknn", "lubridate", 
  "magrittr", "microbenchmark", "nycflights13", "patchwork", "purrr", "readr", 
  "readxl", "rlang", "rnaturalearth", "rnaturalearthdata", "rpart", "rpart.plot", 
  "sf", "tictoc", "tidymodels", "tidyr", "tidyverse", "tweedie", "vroom"
)

# Install all packages (installs only those not already installed)
install.packages(packages)
liba

library(tidyverse)
library(ggplot2)

# Forcats -----------------------------------------------------------------

levels(gss_cat$race)

#Checking the levels
gss_cat %>% 
  select(race) %>% 
  table()

#Dropping levels that are empty
gss_cat %>% 
  mutate(race = fct_drop(race)) %>% 
  select(race) %>% 
  table()

#Re-Level factors
gss_cat %>% 
  mutate(race = fct_drop(race)) %>% 
  mutate(race = fct_relevel(race,c("White","Black","Other"))) %>% 
  select(race) %>% 
  table()

# Freq-factors

gss_cat %>% 
  mutate(marital = fct_infreq(marital),
         marital = fct_rev(marital)) %>% 
  ggplot(aes(marital))+
  geom_bar(fill="steelblue")

# Summarize and reorder

gss_cat %>% 
  group_by(relig) %>% 
  summarise(meantv= mean(tvhours, na.rm = T)) %>% 
  mutate(relig = fct_reorder(relig, meantv)) %>% 
  ggplot(aes(meantv, relig))+
  geom_point(size = 4, color ="steelblue")

# Recode
  #Helps convert levels to one categorical
 #Collapse can be used with c() to combine levels to one
gss_cat
gss_cat %>% 
  mutate(denom = fct_recode(denom, 
                            "Other" = "No denomination",
                            "Other" = "Not applicable"))

# Operators ---------------------------------------------------------------

# & #and
# ! #not
# | #or == option+7
# ~ # == option + ^
# 
# Comments # Ctrl+Shift+C
  
# IF, else_IF, else -------------------------------------------------------
if (..== x){
  print(...)
}
else if (.. == x){
  print(....)
}
else{
  
}

# While loops -------------------------------------------------------------
x<- 0

while (x<10){
  print(paste("x is " ,x))
  x<- x+1
 
  if(x==10){
    print("The value is equal to 10")
    break
    print("Hello")
  } 
}

# For loops ---------------------------------------------------------------

v1 <- c(1,2,3)

for (i in v1) {
  print(i)
}

#Nested for loops
mat<- matrix(1:25, nrow = 5)

for (row in 1:nrow(mat)) {
  for (col in 1:ncol(mat)) {
    print(paste("The element on row", row, "and column", col, "is ", mat[row,col]))
  }
}


# Functions ---------------------------------------------------------------

hello <- function(name){
  print(paste("Hello",name))
}

hello("Brede")

add_sum <- function(add1,add2){
  zum <- add1+add2
  #Use values for later
  return(zum)
}

z <- add_sum(4,5)
z

# The key thing to remember with functions is to know the difference
# between global scrope and local scope, variables declared inside
# a funtion stays inside a function. 


# Advanced, R-programming -------------------------------------------------

is.list(z)
#Transform the types
as.matrix(z)

#Sample, random

sample(1:10,3)

# Regular expressions -----------------------------------------------------

#grepl
#grep

#Finne ord i text -> T/F
text <- "Hey, do you know who you are voting for?"
grepl("voting", text)
grep("voting", text) #<- Indexering i vanlig tekst blir det 1. 

IsMerc <- mtcars2$Names %>% 
  grepl("Merc",.) %>% 
  data_frame() %>% 
  rename("Ismerc" = "." )

mtcars2<- cbind(mtcars, 
      data.frame( Names = rownames(mtcars)
      ), IsMerc)

mtcars2 %>% 
  filter(Ismerc == T)

#Sepearet method
mtcars2 %>% 
  separate(Names, c("Model","Number"))


# Dates -------------------------------------------------------------------
library(lubridate)
#Dagens dato
Sys.Date()

#Konvertering til dato og format
random_date <- "13-05-1998"
random_date <-  dmy(random_date)
random_date <- ymd(random_date)
random_date

is.Date(random_date)

# dplyr -------------------------------------------------------------------
library(nycflights13)
head(flights)
str(flights)
summary(flights)
filter(
  
)

#Filter multiple
filter(flights, month == 11, day == 3, carrier=="AA")

#Slice rows
slice(flights, 1:10)

#Arrange cumulative
head(arrange(flights, year,month,day, arr_time))

#Select is unique
distinct(select(flights,carrier))

#Mutate
mutate(flights, newcol = arr_delay- dep_delay)

#Transmute only return the new col u create*

#Summarise aggregated sums
summarise(flights, avg_air_time=mean(air_time,na.rm=T))

#Sample_n is just a simple of a dataset

#Sample_frac is a percentage of a dataset
sample_frac(flights, 0.1)


xx<- cbind(mtcars,data.frame(row.names(mtcars)))
xx<- xx %>% 
separate(row.names.mtcars., c("Names", "Model"))

xx<- xx %>% 
  mutate(Names = as.factor(Names))

# Process the data
xx <- xx %>%
  mutate(
    Names = fct_infreq(Names), # Order by frequency
    Names = fct_lump_min(Names, 6, other_level = "Other") # Group infrequent levels
  )


# Create the plot
ggplot(xx, aes(x = Names)) +
  geom_bar() +
  labs(
    title = "Distribution of Names",
    x = "Names",
    y = "Count"
  ) +
  theme_minimal()

# Gather ------------------------------------------------------------------

stocks <- tibble(
  time = as.Date("2009-01-01") + 0:9,
  X = rnorm(10, 0, 1),
  Y = rnorm(10, 0, 2),
  Z = rnorm(10, 0, 4)
)

stocks
gather(stocks, "stock", "price", -time)
stocks %>% gather("stock", "price", -time)


# Seperate ----------------------------------------------------------------

# If you want to split by any non-alphanumeric value (the default):
df <- tibble(x = c(NA, "x.y", "x.z", "y.z"))
df %>% separate(x, c("A", "B"))


# GGplot ------------------------------------------------------------------

# Storing the graph data instructions in a variable called pl
pl <- mtcars %>% 
  ggplot(
    aes(
      x=mpg, y=hp
))
# Plotting with a scatter plot, storing in a var
plx <- pl+geom_point()

# Facet graphing based on cylinder type
ply <- plx+facet_grid(cyl~.)+ stat_smooth()

# Great for given a specific range
ply+ coord_cartesian(xlim = c(15,25)) + theme_bw()


library(ggplot2movies)

#Only need one of the axis for the frequency
str(movies)
head(movies)
hist_ = movies %>% 
  ggplot(
    aes(
      x = rating
    )
  )
hist_2 <- hist_+ geom_histogram(binwidth = 0.1, color = "blue", fill="cyan" ,alpha = 0.1, aes(fill =..count..))
hist_2 <- hist_+ geom_histogram(binwidth = 0.1,alpha = 1, aes(fill =..count..))

hist_3 <- hist_2 + xlab("Movie Ratings") + ylab("Count")
hist_3 + ggtitle("Amount of ratings, Movies")


# Two variables -----------------------------------------------------------


df<- mtcars
head(df)
df_p<- df %>% ggplot(aes(x= wt, y= mpg))

#Remember to use AES to modify the graph in geometry
#Based out of other columns in the dataset
df_p1<- df_p + geom_point(alpha=0.9,
                  aes(
                    #Making the cylinder categorical
                    shape=factor(cyl),
                    size=factor(cyl),
                    color= factor(cyl)
                    ))+
  theme_minimal()

df_p2 <- df_p + geom_point(alpha = 0.8, aes(color=hp), size=5)

df_p2 + scale_color_gradient(low = "blue", high = "red")


#Difference between Histogram and Bar plot is that Bar plots
# use categorical data on the x axis

df<- mpg
df

#Position dodge
df_b <- df %>% ggplot(aes(x=class))
df_b + geom_bar(aes(
  color= factor(drv),
  fill= factor(drv)
  ), position = "dodge")

#Percentage of whatever
df_b <- df %>% ggplot(aes(x=class))
df_b + geom_bar(aes(
  color= factor(drv),
  fill= factor(drv)
), position = "fill")

#Boxplot
df <- mtcars
df<- df %>% ggplot(
  aes(
    x= factor(cyl),
    y= mpg
  ))

#There might come an error because x axis needs to be a categorical variable
# Can flip the data with coord flip
#Boxplots represents the 4 quartiles, where the box is the second to third 25-75%
# The line represented in the box represents the median and the outliners
# represent the data outside og extreme values

df + geom_boxplot() + coord_flip()



# 2 var plotting ----------------------------------------------------------
library(hexbin)

pl <- movies %>% ggplot(
  aes(
    x= year,
    y= rating
  ))

#BIN
pl + geom_bin2d(binwidth = c(3,1)) + 
  scale_fill_gradient(high = "red", low = "blue")
#HEX
pl + geom_hex() + 
  scale_fill_gradient(high = "red", low = "blue")
#Density

pl + geom_density2d() 

#Facit grid

#The syntax for x axis is 
facet_grid(cyl~. )

#The syntax for y axis is 
facet_grid(.~cyl )


#Themes
library(dplyr)
library(tidyr)
library(ggplot2)
library(ggthemes )


#theme_set(theme_minimal())
pl <- mtcars %>% 
  ggplot(aes(
    x= wt, y = mpg 
  ))+
  geom_point()

#Well known themes
pl + theme_economist()
pl + theme_fivethirtyeight()
pl + theme_wsj()

head(mtcars)

#Geom smooth
ggplot(mpg, aes(displ, hwy, colour = class)) +
  geom_point() +
  geom_smooth(se = FALSE, method = "lm", formula = y~log(x))

#Worth looking into PLOTLY

# Introduction to Machine Learning ----------------------------------------

# any(is.na(df)) if any values in a df is na values

#Corr graphing
library(nycflights13)
library(tidyr)
library(dplyr)

num.cols<- mtcars %>% 
  sapply(.,is.numeric)

cor.data <- cor(mtcars[,num.cols])
print(cor.data)

library(corrplot)
print(corrplot(cor.data, method = "color"))

# First you would need the catools to get the sample split
# Then you would need to make the split where example
# 70% is training data and 30% is test data
#Training data
library(caTools)
set.seed(10)
#Making a training data in this case 70%
sample <- sample.split(mtcars$cyl, SplitRatio = 0.7)
train<- subset(mtcars, sample == T)
test <- subset(mtcars, sample == F)

#Building the model
model <- lm(cyl ~ ., train )

summary(model)

res<- residuals(model)
res <- as.data.frame(res)
head(res)

library(ggplot2)
ggplot(res,aes(res))+ geom_histogram(fill="blue",binwidth = 0.3)

#Plot(model) for advanced models

#Predictions
Cyl.predictions<- predict(model,test)
results <- cbind(Cyl.predictions,test$cyl )
colnames(results)<- c("predicted", "actual")
results <- as.data.frame(results)
head(results)

#Take care of negative values

to_zero <- function(x){
  if(x<0){
    return(0)
  }else{
    return(x)
  }
}

results$predicted <- sapply(results$predicted, to_zero)


#Mean Squared Error

mse <- mean((results$actual-results$predicted)^2)
print(mse)

print(mse^0.5)



# K-nearest neighbours ----------------------------------------------------

# Standardize the data with scale


