
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


spam_split <- initial_split(spam, prop = 0.75, strata = spam)
df.train <- training(spam_split)
df.test <- testing(spam_split)

folds <- vfold_cv(df.train, v= 5)
rec <- recipe(spam ~. , data = spam)

mod <- nearest_neighbor()%>% 
  set_mode("classification") %>% 
  set_engine("kknn")

wf <- workflow() %>% 
  add_model(mod) %>% 
  add_recipe(rec)

tuned <- fit_resamples(
  wf,
  resamples = folds,
  control = control_resamples(T)
)

best <- select_best(tuned, metric = "roc_auc")

adj <- finalize_workflow(wf, best)

fitted <- fit(adj, data=df.train)

p_test <- cbind(predict(fitted , new_data = df.test, type = "prob"),df.test)
p_train <- cbind(predict(fitted , new_data = df.train, type = "prob"), df.train)

roc_auc(data = p_test, truth = spam, .pred_0)
roc_auc(data = p_train, truth = spam, .pred_0)
