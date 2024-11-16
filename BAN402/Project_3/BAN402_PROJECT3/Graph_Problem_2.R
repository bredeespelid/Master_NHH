library(readr)
library(dplyr)
library(ggplot2)

data <- read_delim("Problem_2.txt", delim = "\t", col_names = TRUE)
print(data)

equilibrium_points <- data.frame(Time_period = integer(), Volume_eq = numeric(), Value_eq = numeric())

for (period in unique(data$`Time period`)) {
  data_period <- data %>% filter(`Time period` == period)
  lm_supply <- lm(Supply ~ Volume, data = data_period)
  lm_demand <- lm(Demand ~ Volume, data = data_period)
  Volume_eq <- (coef(lm_demand)[1] - coef(lm_supply)[1]) / (coef(lm_supply)[2] - coef(lm_demand)[2])
  Value_eq <- coef(lm_supply)[1] + coef(lm_supply)[2] * Volume_eq
  equilibrium_points <- rbind(equilibrium_points, data.frame(Time_period = period, Volume_eq = Volume_eq, Value_eq = Value_eq))
}

plot <- ggplot(data, aes(x = Volume)) +
  labs(title = "Supply and Demand with Equilibrium Points",
       x = "Volume",
       y = "Price",
       color = "Time Period") +
  theme_minimal(base_size = 15) +
  scale_color_manual(values = c("red", "blue", "green", "purple", "orange")) +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"),
        legend.position = "bottom")

for (period in unique(data$`Time period`)) {
  data_period <- data %>% filter(`Time period` == period)
  plot <- plot +
    geom_smooth(data = data_period, aes(y = Supply, color = as.factor(`Time period`)), 
                method = "lm", linetype = "solid", size = 1, se = FALSE, na.rm = TRUE) +
    geom_smooth(data = data_period, aes(y = Demand, color = as.factor(`Time period`)), 
                method = "lm", linetype = "solid", size = 1, se = FALSE, na.rm = TRUE)
}

plot <- plot +
  geom_point(data = equilibrium_points, aes(x = Volume_eq, y = Value_eq, color = as.factor(Time_period)),
             size = 4, shape = 21, fill = "yellow", stroke = 1.5) +
  geom_vline(xintercept = 1200, color = "black", linetype = "dashed", size = 1) +
  geom_hline(yintercept = 11, color = "black", linetype = "dashed", size = 1)

print(plot)

intersection_points <- data.frame(Time_period = integer(), Demand_at_1200 = numeric(), Supply_at_1200 = numeric())

for (period in unique(data$`Time period`)) {
  data_period <- data %>% filter(`Time period` == period)
  lm_supply <- lm(Supply ~ Volume, data = data_period)
  lm_demand <- lm(Demand ~ Volume, data = data_period)
  Supply_at_1200 <- predict(lm_supply, newdata = data.frame(Volume = 1200))
  Demand_at_1200 <- predict(lm_demand, newdata = data.frame(Volume = 1200))
  intersection_points <- rbind(intersection_points, data.frame(Time_period = period, Demand_at_1200 = Demand_at_1200, Supply_at_1200 = Supply_at_1200))
}

for (i in 1:nrow(intersection_points)) {
  cat("Period", intersection_points$Time_period[i], ":\n")
  cat("Demand at Volume 1200:", round(intersection_points$Demand_at_1200[i], 2), "\n")
  cat("Supply at Volume 1200:", round(intersection_points$Supply_at_1200[i], 2), "\n\n")
}

print(plot)
