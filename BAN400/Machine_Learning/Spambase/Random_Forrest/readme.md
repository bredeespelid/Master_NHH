# README for Decision Tree and Random Forest Model Setup

This README explains how to set up and fine-tune decision tree and random forest models step-by-step. Each section breaks down what the code does in simple terms.

## 1. Prepare the Data
Split the data into training and test datasets, and create folds for cross-validation:
```R
# Split the data into training and test data, and divide the training data into folds for cross-validation
set.seed(1)
spam_split <- initial_split(spam, strata = spam)
spam_train <- training(spam_split)
spam_test  <- testing(spam_split)

spam_folds <- vfold_cv(spam_train, strata = spam, v = 3)  # v = 5 or 10 is more common
```
- **`initial_split`**: Splits the data into training and testing sets.
- **`vfold_cv`**: Creates cross-validation folds.

## 2. Define the Recipe
Specify the preprocessing steps common to all models:
```R
# Specify the recipe, that is common for all models
spam_recipe <- 
  recipe(spam ~ ., data = spam) 
```
- **`recipe`**: Defines the pre-processing steps for the data.

## 3. Create the Decision Tree Model
Here, we define the decision tree and specify the settings we want to adjust:
```R
# Specify the decision tree
tree_mod <- 
  decision_tree(
    tree_depth = tune(),
    min_n = tune()) %>%
  set_mode("classification") %>% 
  set_engine("rpart") 
```
- **`tree_depth`**: How deep the tree can grow.
- **`min_n`**: Minimum number of data points required to split a node.

## 4. Set Up the Workflow for Decision Tree
Combine the model and the data preparation steps into one pipeline:
```R
# Set up the workflow
tree_workflow <- 
  workflow() %>% 
  add_model(tree_mod) %>% 
  add_recipe(spam_recipe)
```
- **`workflow`**: Combines the recipe (data preparation) and the model into one.

## 5. Create a Tuning Grid for Decision Tree
Define different combinations of `tree_depth` and `min_n` to test:
```R
# Make a search grid for the parameters
tree_grid <- 
  grid_latin_hypercube(
    tree_depth(),
    min_n(),
    size = 10
)
```
- **`grid_latin_hypercube`**: Generates a set of parameter combinations to test.

## 6. Test the Decision Tree Model with Cross-Validation
Use cross-validation to find the best parameter combination:
```R
# Cross-validate and calculate AUC
tree_tune_result <- 
  tune_grid(
    tree_workflow,
    resamples = spam_folds,
    grid = tree_grid,
    control = control_grid(save_pred = TRUE)
  )
```
- **`resamples`**: Splits the data for cross-validation.
- **`control_grid`**: Keeps track of predictions.

## 7. Pick the Best Parameters for Decision Tree
Find the parameter settings that performed the best:
```R
# Find the best parameters
tree_tune_result %>%
  select_best(metric = "roc_auc") 
```
- **`select_best`**: Selects the combination that gave the highest AUC score.

## 8. Finalize the Workflow for Decision Tree
Apply the best parameters to the workflow:
```R
# Finalize the workflow
tree_tuned <- 
  finalize_workflow(
    tree_workflow,
    parameters = tree_tune_result %>% select_best(metric = "roc_auc")
  )
```

## 9. Train the Decision Tree Model
Fit the model on the training data:
```R
# Train the model
fitted_tree <- 
  tree_tuned %>% 
  fit(data = spam_train)
```

## 10. Create the Random Forest Model
Define the random forest model and specify tunable settings:
```R
# Specify the random forest model
rf_mod <- 
  rand_forest(
    mtry  = tune(),
    trees = 1000,
    min_n = tune()) %>%
  set_mode("classification") %>% 
  set_engine("ranger")
```
- **`mtry`**: Number of variables randomly sampled at each split.
- **`trees`**: Total number of trees in the forest.
- **`min_n`**: Minimum number of data points in a node.

## 11. Set Up the Workflow for Random Forest
Combine the random forest model with the data preparation steps:
```R
# Set up the workflow
rf_workflow <- 
  workflow() %>% 
  add_model(rf_mod) %>% 
  add_recipe(spam_recipe)
```

## 12. Create a Tuning Grid for Random Forest
Generate a grid of hyperparameter combinations:
```R
# Make a search grid for the parameters
rf_grid <- 
  grid_latin_hypercube(
    mtry(range = c(1, length(names)/2)),
    min_n(),
    size = 10
)
```

## 13. Test the Random Forest Model with Cross-Validation
Evaluate the random forest model across folds:
```R
# Cross-validate and calculate AUC
rf_tune_result <- 
  tune_grid(
    rf_workflow,
    resamples = spam_folds,
    grid = rf_grid,
    control = control_grid(save_pred = TRUE)
  )
```

## 14. Pick the Best Parameters for Random Forest
Select the best-performing combination of parameters:
```R
# Find the best parameters
rf_tune_result %>%
  select_best(metric = "roc_auc") 
```

## 15. Finalize the Workflow for Random Forest
Apply the best parameters to the random forest workflow:
```R
# Finalize the workflow
rf_tuned <- 
  finalize_workflow(
    rf_workflow,
    parameters = rf_tune_result %>% select_best(metric = "roc_auc")
  )
```

## 16. Train the Random Forest Model
Fit the random forest model on the training data:
```R
# Train the model
fitted_rf <- 
  rf_tuned %>% 
  fit(data = spam_train)
```

## 17. Make Predictions with Random Forest
Generate predictions for both training and test datasets:
```R
# Make predictions
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
```

## 18. Evaluate the Random Forest Model
Calculate AUC for both training and test predictions:
```R
# Calculate the AUC
auc_rf <-
  predictions_rf_test %>% 
  roc_auc(truth, .pred_0) %>% 
  mutate(where = "test") %>% 
  bind_rows(predictions_rf_train %>% 
              roc_auc(truth, .pred_0) %>% 
              mutate(where = "train")) %>% 
  mutate(model = "rand_forest")
```

## 19. Compare Decision Tree and Random Forest Results
Combine the AUC results for both models:
```R
# Compare the results
bind_rows(auc_tree, auc_rf)
```
- **`bind_rows`**: Combines the AUC results for easier comparison.

By following these steps, you can build, tune, and evaluate both decision tree and random forest models.
