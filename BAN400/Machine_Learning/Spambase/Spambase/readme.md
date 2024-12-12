# Decision Tree Model Setup

This README explains how to set up and fine-tune a decision tree model step-by-step. Each section breaks down what the code does in simple terms.

## 1. Create the Decision Tree Model
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

## 2. Set Up the Workflow
Combine the model and the data preparation steps into one pipeline:
```R
# Set up the workflow
tree_workflow <- 
  workflow() %>% 
  add_model(tree_mod) %>% 
  add_recipe(spam_recipe)
```
- **`workflow`**: Combines the recipe (data preparation) and the model into one.

## 3. Create a Tuning Grid
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

## 4. Test the Model with Cross-Validation
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

## 5. Pick the Best Parameters
Find the parameter settings that performed the best:
```R
# Find the best parameters
tree_tune_result %>%
  select_best(metric = "roc_auc") 
```
- **`select_best`**: Selects the combination that gave the highest AUC score.

## 6. Finalize the Workflow
Apply the best parameters to the workflow:
```R
# Finalize the workflow
tree_tuned <- 
  finalize_workflow(
    tree_workflow,
    parameters = tree_tune_result %>% select_best(metric = "roc_auc")
  )
```

## 7. Train the Model
Fit the model on the training data:
```R
# Train the model
fitted_tree <- 
  tree_tuned %>% 
  fit(data = spam_train)
```

## 8. Visualize the Tree
Draw the decision tree:
```R
# Plot the tree
rpart.plot(fitted_tree$fit$fit$fit)
```
- **`rpart.plot`**: Creates a diagram of the decision tree.

## 9. Make Predictions
Predict the outcomes for both training and test data:
```R
# Make predictions
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
```

## 10. Evaluate the Model
Check the model's performance by calculating the AUC (Area Under the Curve):
```R
# Calculate the AUC
auc_tree <-
  predictions_tree_test %>% 
  roc_auc(truth, .pred_0) %>% 
  mutate(where = "test") %>% 
  bind_rows(predictions_tree_train %>% 
              roc_auc(truth, .pred_0) %>% 
              mutate(where = "train")) %>% 
  mutate(model = "decision_tree")
```
- **`roc_auc`**: Measures how well the model separates the classes.

By following these steps, you can build, tune, and evaluate a decision tree model.
