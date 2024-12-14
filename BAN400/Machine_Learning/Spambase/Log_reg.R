
## ------    DATA SOURCE:   https://archive.ics.uci.edu/ml/datasets/spambase
## ------

# Load packages -----
library(readr)
library(dplyr)
library(rpart)           # For decision trees
library(rpart.plot)      # Separate package for plotting trees
library(dials)
library(tidyverse)
library(tidymodels)

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


# __ ----------------------------------------------------------------------


spam_split <- initial_split(spam, prop = 0.8, strata = spam)
df.test <- testing(spam_split)
df.train <- training(spam_split)
folds <- vfold_cv(df.train, v = 5)
rec <- recipe(spam ~. , data = spam )

mod <- logistic_reg() %>% 
  set_mode("classification") %>% 
  set_engine("glm")

wf <- workflow() %>% 
  add_model(mod) %>% 
  add_recipe(rec)

tuned <- fit_resamples(
  wf,
  resamples = folds,
  control = control_resamples(save_pred = T)
)

best <- select_best(tuned,metric =   "roc_auc")

fwf <- finalize_workflow(wf, best)

fitted_model <- fit(wf, data = df.train)

pred_train <- predict( fitted_model,new_data = df.train, type = "prob") %>% 
  cbind(df.train)

pred_test <- predict( fitted_model,new_data = df.test, type = "prob") %>% 
  cbind(df.test)

rbind(
roc_auc(pred_train, truth = spam, .pred_0),
roc_auc(pred_test, truth = spam, .pred_0)
)
