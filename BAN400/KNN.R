# Load libraries
library(tidymodels)

# Split data into training and testing sets
set.seed(123)
data_split <- initial_split(titanic, prop = 0.8, strata = Survived)
train_data <- training(data_split)
test_data <- testing(data_split)

# Create a recipe
knn_recipe <- recipe(Survived ~ ., data = train_data)

# Define the KNN model with default parameters
knn_model <- nearest_neighbor() %>%
  set_engine("kknn") %>%
  set_mode("classification")

# Create a workflow
knn_workflow <- workflow() %>%
  add_recipe(knn_recipe) %>%
  add_model(knn_model)

# Fit the KNN model to the training data
knn_fit <- fit(knn_workflow, data = train_data)

# Predict on test data
test_predictions <- predict(knn_fit, test_data, type = "prob")

# Add predictions to the test dataset
test_data <- bind_cols(test_data, test_predictions)

# Calculate AUC for the test data
knn_auc <- roc_auc(
  data = test_data,
  truth = Survived,
  .pred_1  # Probability for class "1" (survived)
)

print(knn_auc)
