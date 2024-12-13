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

# 3. Define the KNN model with a tunable parameter
knn_model <- nearest_neighbor(neighbors = tune()) %>%
  set_engine("kknn") %>%
  set_mode("classification")

# 4. Define the recipe
knn_recipe <- recipe(target ~ ., data = train_data)

# 5. Create the workflow
knn_workflow <- workflow() %>%
  add_recipe(knn_recipe) %>%
  add_model(knn_model)

# 6. Set up a tuning grid
knn_grid <- grid_regular(
  neighbors(range = c(1, 50)),
  levels = 10
)

# 7. Perform hyperparameter tuning
set.seed(123)
knn_results <- tune_grid(
  knn_workflow,
  resamples = folds,
  grid = knn_grid,
  metrics = metric_set(roc_auc)
)

# 8. Select the best parameters
best_knn_params <- select_best(knn_results, "roc_auc")

# 9. Finalize the workflow with the best parameters
final_knn_workflow <- finalize_workflow(knn_workflow, best_knn_params)

# 10. Fit the final model on the training data
final_knn_model <- fit(final_knn_workflow, data = train_data)

# 11. Predict on test data
test_predictions <- predict(final_knn_model, test_data, type = "prob")

# 12. Calculate AUC for test data
test_auc <- roc_auc_vec(
  truth = test_data$target,
  estimate = test_predictions$.pred_1
)
print(test_auc)
