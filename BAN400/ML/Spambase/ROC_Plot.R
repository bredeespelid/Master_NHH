
library(yardstick)
library(ggplot2)

# ROC-kurve for testsettet
roc_test <- roc_curve(p_test, truth = spam, .pred_0)

# ROC-kurve for treningssettet
roc_train <- roc_curve(p_train, truth = spam, .pred_0)

# Legg til en kolonne for å identifisere datasett
roc_test <- roc_test %>% mutate(dataset = "Test")
roc_train <- roc_train %>% mutate(dataset = "Train")

# Kombiner dataene
roc_data <- bind_rows(roc_test, roc_train)

# Plot ROC-kurver
ggplot(roc_data, aes(x = 1 - specificity, y = sensitivity, color = dataset)) +
  geom_line(size = 1) +
  labs(
    title = "ROC Curve",
    x = "1 - Specificity (False Positive Rate)",
    y = "Sensitivity (True Positive Rate)",
    color = "Dataset"
  ) +
  theme_minimal() +
  coord_equal()

