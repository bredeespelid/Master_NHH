# Load libraries
library(tidymodels)

# 1. Split the dataset
set.seed(123)
data_split <- initial_split(data, prop = 0.8)
train_data <- training(data_split)
test_data <- testing(data_split)

# 2. Create cross-validation folds
set.seed(123)
folds <- vfold_cv(train_data, v = 5)

# 3. Define the logistic regression model
log_reg_model <- logistic_reg() %>%
  set_engine("glm") %>%
  set_mode("classification")

# 4. Define the recipe
log_reg_recipe <- recipe(target ~ ., data = train_data)

# 5. Create the workflow
log_reg_workflow <- workflow() %>%
  add_recipe(log_reg_recipe) %>%
  add_model(log_reg_model)

# 6. Fit resamples (cross-validation)
set.seed(123)
log_reg_results <- fit_resamples(
  log_reg_workflow,
  resamples = folds,
  metrics = metric_set(roc_auc)
)

# 7. Collect metrics
log_reg_metrics <- collect_metrics(log_reg_results)
print(log_reg_metrics)

# 8. Fit the final model on the training data
final_log_reg_model <- fit(log_reg_workflow, data = train_data)

# 9. Predict on test data
test_predictions <- predict(final_log_reg_model, test_data, type = "prob")

# 10. Calculate AUC for test data
test_auc <- roc_auc_vec(
  truth = test_data$target,
  estimate = test_predictions$.pred_1
)
print(test_auc)
