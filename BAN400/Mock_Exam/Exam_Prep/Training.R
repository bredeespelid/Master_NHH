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
install.packages("ISLR")
library(ISLR)
library(caTools)
str(Caravan)
summary(Caravan$Purchase)

any(is.na(Caravan))


var(Caravan[,1])
var(Caravan[,2])

purchase <- Caravan[,86]

# Important to standardize when dealing with K-neaerst neighbors
# Because of the distance

standardized.Caravan <- scale(Caravan[,-86])
print(var(standardized.Caravan[,1]))
print(var(standardized.Caravan[,2]))

test.index<- 1:1000
test.data <- standardized.Caravan[test.index,]
test.purchase <- purchase[test.index]

train.data <- standardized.Caravan[-test.index,]
train.purchase <- purchase[-test.index]

#Building the KNN MODEL

library(class)
set.seed(101)
predicted.purchase <- knn(train.data,test.data,train.purchase, k=1)

print(head(predicted.purchase))

# Load packages -----
library(readr)
library(dplyr)
library(tidymodels)
library(rpart)           # For decision trees
library(rpart.plot)      # Separate package for plotting trees
library(ranger)

# Read data ------
names <- 
  read_csv("spambase.names", 
           skip = 32,
           col_names = FALSE) %>% 
  separate(X1,
           into = c("name", "drop"),
           sep = ":") %>% 
  select(-drop) %>% 
  bind_rows(tibble(name = "spam")) %>% 
  pull


spam <- 
  read_csv("spambase.data", col_names = names) %>% 
  mutate(spam = as.factor(spam))

# What is the distribution of spam e-mail in the data set?
spam %>% 
  group_by(spam) %>% 
  summarize(n_emails = n()) %>% 
  mutate(share = n_emails/sum(n_emails))

# Split the data into training and test data, and divide the training data into
# folds for cross-validaton.
set.seed(1)
spam_split <- initial_split(spam, strata = spam)
spam_train <- training(spam_split)
spam_test  <- testing (spam_split)

spam_folds <- vfold_cv(spam_train, strata = spam, v = 3)  # v = 5 or 10 is more common

# Specify the recipe, that is common for all models
spam_recipe <- 
  recipe(spam ~ ., data = spam) 

# DECISION TREE -------------

# Specify the decistion tree
tree_mod <- 
  decision_tree(
    tree_depth = tune(),
    min_n = tune()) %>%
  set_mode("classification") %>% 
  set_engine("rpart") 

# Set up the workflow
tree_workflow <- 
  workflow() %>% 
  add_model(tree_mod) %>% 
  add_recipe(spam_recipe)

# Make a search grid for the k-parameter
tree_grid <- 
  grid_latin_hypercube(
    tree_depth(),
    min_n(),
    size = 10
  )

# Calculate the cross-validated AUC for all the k's in the grid
tree_tune_result <- 
  tune_grid(
    tree_workflow,
    resamples = spam_folds,
    grid = tree_grid,
    control = control_grid(save_pred = TRUE)
  )

# Which parameter combination is the best?
tree_tune_result %>%
  select_best(metric = "roc_auc") 

# Put the best parameters in the workflow
tree_tuned <- 
  finalize_workflow(
    tree_workflow,
    parameters = tree_tune_result %>% select_best(metric = "roc_auc")
  )

# Fit the model
fitted_tree <- 
  tree_tuned %>% 
  fit(data = spam_train)

# Plot the model
rpart.plot(fitted_tree$fit$fit$fit)

# Predict the train and test data
predictions_tree_test <- 
  fitted_tree %>% 
  predict(new_data = spam_test,
          type = "prob") %>% 
  mutate(truth = spam_test$spam) 

predictions_tree_train <- 
  fitted_tree %>% 
  predict(new_data = spam_train,
          type = "prob") %>% 
  mutate(truth = spam_train$spam) 


# Calculate the AUC
auc_tree <-
  predictions_tree_test %>% 
  roc_auc(truth, .pred_0) %>% 
  mutate(where = "test") %>% 
  bind_rows(predictions_tree_train %>% 
              roc_auc(truth, .pred_0) %>% 
              mutate(where = "train")) %>% 
  mutate(model = "decision_tree")

# RANDOM FOREST -------
rf_mod <- 
  rand_forest(
    mtry  = tune(),
    trees = 1000,
    min_n = tune()) %>%
  set_mode("classification") %>% 
  set_engine("ranger")

# Set up the workflow
rf_workflow <- 
  workflow() %>% 
  add_model(rf_mod) %>% 
  add_recipe(spam_recipe)

# Make a search grid for the parameters
rf_grid <- 
  grid_latin_hypercube(
    mtry(range = c(1, length(names)/2)),
    min_n(),
    size = 10
  )

# Calculate the cross-validated AUC for all the parameter combinations in the
# grid
rf_tune_result <- 
  tune_grid(
    rf_workflow,
    resamples = spam_folds,
    grid = rf_grid,
    control = control_grid(save_pred = TRUE)
  )

# Which parameter combination is the best?
rf_tune_result %>%
  select_best(metric = "roc_auc") 

# Put the best parameters in the workflow
rf_tuned <- 
  finalize_workflow(
    rf_workflow,
    parameters = rf_tune_result %>% select_best(metric = "roc_auc")
  )

# Fit the model
fitted_rf <- 
  rf_tuned %>% 
  fit(data = spam_train)

# Predict the train and test data
predictions_rf_test <- 
  fitted_rf %>% 
  predict(new_data = spam_test,
          type = "prob") %>% 
  mutate(truth = spam_test$spam) 

predictions_rf_train <- 
  fitted_rf %>% 
  predict(new_data = spam_train,
          type = "prob") %>% 
  mutate(truth = spam_train$spam) 


# Calculate the AUC
auc_rf <-
  predictions_rf_test %>% 
  roc_auc(truth, .pred_0) %>% 
  mutate(where = "test") %>% 
  bind_rows(predictions_rf_train %>% 
              roc_auc(truth, .pred_0) %>% 
              mutate(where = "train")) %>% 
  mutate(model = "rand_forest")

# Compare the results
bind_rows(auc_tree, auc_rf)

# We see that the random forest is much better -- makes almost perferct
# classifications.


xgb_mod <- 
  boost_tree(
    trees = 1000, 
    tree_depth = tune(), min_n = tune(), 
    loss_reduction = tune(),                     
    sample_size = tune(), mtry = tune(),        
    learn_rate = tune(),                         
  ) %>%
  set_mode("classification") %>% 
  set_engine("xgboost")

# Set up the workflow
xgb_workflow <- 
  workflow() %>% 
  add_model(xgb_mod) %>% 
  add_recipe(spam_recipe)

# Make a search grid for the parameters
xgb_grid <- grid_latin_hypercube(
  tree_depth(),
  min_n(),
  loss_reduction(),
  sample_size = sample_prop(),
  finalize(mtry(), spam_train),
  learn_rate(),
  size = 30
)

# Calculate the cross-validated AUC for all the parameter combinations in the
# grid
xgb_tune_result <- 
  tune_grid(
    xgb_workflow,
    resamples = spam_folds,
    grid = xgb_grid,
    control = control_grid(save_pred = TRUE)
  )

# Which parameter combination is the best?
xgb_tune_result %>%
  select_best(metric = "roc_auc") 

# Put the best parameters in the workflow
xgb_tuned <- 
  finalize_workflow(
    xgb_workflow,
    parameters = xgb_tune_result %>% select_best(metric = "roc_auc")
  )

# Fit the model
fitted_xgb <- 
  xgb_tuned %>% 
  fit(data = spam_train)

# Predict the train and test data
predictions_xgb_test <- 
  fitted_xgb %>% 
  predict(new_data = spam_test,
          type = "prob") %>% 
  mutate(truth = spam_test$spam) 

predictions_xgb_train <- 
  fitted_xgb %>% 
  predict(new_data = spam_train,
          type = "prob") %>% 
  mutate(truth = spam_train$spam) 


# Calculate the AUC
auc_xgb <-
  predictions_xgb_test %>% 
  roc_auc(truth, .pred_0) %>% 
  mutate(where = "test") %>% 
  bind_rows(predictions_xgb_train %>% 
              roc_auc(truth, .pred_0) %>% 
              mutate(where = "train")) %>% 
  mutate(model = "xgboost")

# Compare the results
bind_rows(auc_tree, auc_rf, auc_xgb)

# The xgboost performs approximately the same as the random forest: very close
# to perfect classification.


#Iterations

library(purrr) 
library(tidyverse)

df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)

col_summary <- function(df, fun) {
  out <- vector("double", length(df))
  for (i in seq_along(df)) {
    out[i] <- fun(df[[i]])
  }
  out
}

df |> 
  map(mean, trim=.1) |> 
  bind_cols()

#Anonymous function

mtcars |>                       
  split( ~ cyl) |>              
  map({
    \(x)lm(mpg ~ wt, data = x)
  }) |>
  map(summary) |>
  map({
    \(x) x$r.squared
  }) |>
  bind_cols()


head(mtcars)
str(mtcars)

library(purrr)
mtcars %>% 
  map({
      \(z) 
    
    ceiling(mean(z)%%2)
    
    }) %>% 
  rbind()

# Pivot w/l ------------------------------------------------------

relig_income
relig_income %>%
  pivot_longer(!religion, names_to = "income", values_to = "count")

fish_encounters
fish_encounters %>%
  pivot_wider(names_from = station, values_from = seen)
# Fill in missing values
fish_encounters %>%
  pivot_wider(names_from = station, values_from = seen, values_fill = 0)

# Parallel computing ------------------------------------------------------
library(tidyverse)

load("parallel_data.Rdata")

sales_price_mnok <- 1
car_cost_mnok <- .95

df %>%
  head() %>% 
  knitr::kable()

calcProfits <-
  function(df,
           sales_price_mnok,
           car_cost_mnok,
           lead_days) {
    df %>%
      mutate(
        sales_price_BTC = sales_price_mnok / NOKBTC,
        mNOK_val_sales =
          lead(NOKBTC, lead_days, order_by = date)
        * sales_price_BTC,
        profit_mnok = mNOK_val_sales - car_cost_mnok
      )
  }


initial_equity <- 10

test_neg_equity <-
  function(df, startdate, lead_days) {
    tmpdf <-
      df %>%
      filter(date >= startdate) %>%
      calcProfits(sales_price_mnok, car_cost_mnok, lead_days) %>%
      filter(complete.cases(.))
    
    if (nrow(tmpdf) > 0) {
      tmpdf %>%
        mutate(cumulative_profits_mnok = cumsum(profit_mnok)) %>%
        summarise(negative_equity =
                    1 * (min(
                      cumulative_profits_mnok + initial_equity
                    ) < 0)) %>%
        pull %>%
        return
    } else{
      return(NA_real_)
    }
  }

library(tictoc)

# We can use tictoc to time a function..:
tic()
Sys.sleep(1)
toc()

printTicTocLog <-
  function() {
    tic.log() %>%
      unlist %>%
      tibble(logvals = .) %>%
      separate(logvals,
               sep = ":",
               into = c("Function type", "log")) %>%
      mutate(log = str_trim(log)) %>%
      separate(log,
               sep = " ",
               into = c("Seconds"),
               extra = "drop")
  }

tic.clearlog()

tic("Test")
Sys.sleep(1)
toc(log = TRUE)


df_res <-
  expand.grid(date = df$date,
              lead_days = c(1, 5, 10, 30, 60)) %>%
  mutate(neg_eq = NA) %>%
  as_tibble()


tic.clearlog()
tic("Regular loop")

for (i in 1:nrow(df_res)) {
  df_res$neg_eq[i] <-
    test_neg_equity(df,
                    startdate = df_res$date[i],
                    lead_days = df_res$lead_days[i])
}

toc(log = TRUE)


library(doParallel)

# The function detectCores finds the number of cores
# available on the machine. We update the "Cores"-value
# to the minimum of the chosen cores and the available cores.
maxcores <- 8
Cores <- min(parallel::detectCores(), maxcores)

# Instantiate the cores:
cl <- makeCluster(Cores)

# Next we register the cluster..
registerDoParallel(cl)

# Take the time as before:
tic(paste0("Parallel loop, ", Cores, " cores"))
res <-
  foreach(
    i = 1:nrow(df_res),
    .combine = 'rbind',
    .packages = c('magrittr', 'dplyr')
  ) %dopar%
  tibble(
    date = df_res$date[i],
    lead_days = df_res$lead_days[i],
    neg_eq =
      test_neg_equity(
        df,
        startdate = df_res$date[i],
        lead_days = df_res$lead_days[i]
      )
  )

# Now that we're done, we close off the clusters
stopCluster(cl)

toc(log = TRUE)

library(purrr)

tic("purrr")
df_res$neg_eq <-
  df %>%
  map2_dbl(as.list(df_res$date),
           as.list(df_res$lead_days),
           test_neg_equity,
           df = .)

toc(log = TRUE)


library(furrr)
plan(multisession, workers = Cores)

tic(paste0("furrr, ", Cores, " cores"))

df_res$neg_eq <-
  df %>%
  future_map2_dbl(as.list(df_res$date),
                  as.list(df_res$lead_days),
                  test_neg_equity,
                  df = .)

toc(log = TRUE)


# Many models -------------------------------------------------------------

library(broom)
library(gapminder)
library(nnet)
library(MASS)

example(birthwt)

bwt.mu <- multinom(low ~ ., bwt)

tidy(bwt.mu)
glance(bwt.mu)

# or, for output from a multinomial logistic regression
fit.gear <- multinom(gear ~ mpg + factor(am), data = mtcars)
tidy(fit.gear)
glance(fit.gear)

mtcars
lm.M <- lm(cyl ~ ., data= mtcars)
glance(lm.M)[1,1]


mtcars %>% 
  nest(data = -cyl) %>% 
  mutate(
    model = map(data,{
      
    \(x) lm(mpg~., data=x )
      
  }
  ),
  
  glanc = map(model, glance)
    ) %>% 
  unnest(glanc) %>% 
  select(cyl,)
  


#Machine learning decision tree
install.packages("rpart.plot")
library(rpart.plot)
library(rpart)
library(broom)
str(kyphosis)

head(kyphosis)
head(mtcars)

tree <- rpart(hp ~., method = "class", data =mtcars)
printcp(tree)
#plot(tree, uniform = T, main = "Kyphosis Tree")
#text(tree, use.n=T,all=T)

prp(tree)

#Random forest

install.packages("randomForest")
library(randomForest)
rf.model <- randomForest(Kyphosis~ . , data = kyphosis)

print(rf.model$ntree)


# Patchwork ---------------------------------------------------------------


library(ggplot2)
# You can add plots saved to variables

p1 <- ggplot(mtcars) + geom_point(aes(mpg, disp))
p2 <- ggplot(mtcars) + geom_boxplot(aes(gear, disp, group = gear))

p1 + p2



# Real life example -------------------------------------------------------

library(jsonlite)
library(dplyr)
library(ggplot2)
library(lubridate)
library(tidyr)
library(purrr)
library(lubridate)
library(forcats)
library(ggthemes)
df <- fromJSON('Google_Ratings.json', simplifyVector = T)


df<- df %>% separate(Dato, c("Dato", "UTF"), sep = "T") %>% 
  select(-UTF) %>% 
  unnest(categories)%>% 
  mutate(Dato = ymd(Dato)) %>% 
  separate(Avd, c("Avd","Navn"),sep=" ")
  
df <- as.data.frame(df) %>% 
  rename(Rating = "???") %>% 
  mutate(Avd = as_factor(Avd))

df <- df %>% 
  filter(Avd != "16")

library(janitor)

df <- df %>%
  clean_names()

head(df)

df %>% filter(avd == 23,
              dato > "2022-12-30")

# Antall tilbakemeldinger --------------------------------------------------------


pl <- df %>% filter('Ingen kommentar' != 1) %>% 
  ggplot(aes(
  fct_infreq(Avd)
))
pl+ geom_bar(
  na.rm=T) + 
  theme_wsj()+
  labs(title= "Antall Tilbakemeldinger")

# Fitted ------------------------------------------------------------------

library(janitor)

df <- df %>%
  clean_names()

# colnames(df)
# library(janitor)
# library(ggplot2)
# library(dplyr)
# library(tidyr)
# library(forcats)
# 
# # Rens data og filtrer for ??nsket periode
# df <- df %>%
#   clean_names()
# 
# # Legg til ??r basert p?? dato
# df <- df %>%
#   mutate(aar = case_when(
#     dato >= as.Date("2023-01-01") & dato <= as.Date("2024-12-31") ~ "2023/2024",
#     dato >= as.Date("2022-01-01") & dato <= as.Date("2022-12-31") ~ "2022/2023",
#     TRUE ~ "Tidligere"
#   ))
# 
# # Reshape data til langt format og ta med dato og ??r
# df_long <- df %>%
#   pivot_longer(
#     cols = c(dyre_produkter, darlige_produkter, 
#              darlig_kundeservice_opplevelse, lang_ko_ventetid, 
#              darlig_renhold, ingen_kommentar, annet),
#     names_to = "complaint",
#     values_to = "count"
#   ) %>%
#   filter(complaint != "ingen_kommentar")
# 
# # Oppsummer klager per avdeling og ??r
# df_summary <- df_long %>%
#   group_by(avd, aar, complaint) %>%
#   summarise(total = sum(count), .groups = "drop")
# 
# # Lag et facet wrap-stablet stolpediagram
# ggplot(df_summary, aes(x = fct_inseq(avd), y = total, fill = complaint)) +
#   geom_bar(stat = "identity", color = "black", position = "fill") +
#   labs(title = "Fordeling av klager per Avdeling per ??r",
#        x = "Avdeling",
#        y = "Andel av Klager",
#        fill = "Klagetype") +
#   theme_minimal() +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
#   facet_wrap(~aar, ncol = 1) # Facet wrap for ??r
#   
# head(df)


library(ggplot2)
library(dplyr)
library(tidyr)



# Reshape data to long format
df_long <- df %>%
  pivot_longer(
    cols = c(dyre_produkter, darlige_produkter, 
             darlig_kundeservice_opplevelse, lang_ko_ventetid, 
             darlig_renhold, ingen_kommentar, annet),
    names_to = "complaint",
    values_to = "count"
  ) %>% 
  mutate(aar = case_when(
    dato >= as.Date("2023-01-01") & dato <= as.Date("2024-12-31") ~ "23/24",
    dato >= as.Date("2021-01-01") & dato <= as.Date("2022-12-31") ~ "21/22",
    dato >= as.Date("2019-01-01") & dato <= as.Date("2020-12-31") ~ "19/20",
    TRUE ~ "Tidligere"
  ))

# Summarize the complaint counts per department
df_summary <- df_long %>%
  group_by(avd, complaint, aar) %>%
  filter(aar!="Tidligere") %>% 
  summarise(total = sum(count), .groups = "drop") %>% 
  filter(complaint != "ingen_kommentar" )


# Create a stacked barplot
Fordeling <- ggplot(df_summary, aes(y = fct_inseq(avd), x = total, fill = complaint)) +
  geom_bar(stat = "identity", 
           color = "black"
           ,position = "fill"
           ) +
  labs(title = "Fordeling av klager per Avdeling 2019-2024 (%)",
       x = "Department",
       y = "Total Complaints",
       fill = "Klagetype") +
  theme_wsj() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

Fordeling + facet_grid(aar~.)


# Random forest -----------------------------------------------------------


