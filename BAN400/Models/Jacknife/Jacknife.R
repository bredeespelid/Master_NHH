# Exercises for the many models lesson.
# 

library(tidyverse)
library(readr)
library(tidymodels)
library(purrr)

# Problem 4: Read and tidy the data according to instructions -----
countries <- 
  read_delim("growth.csv", delim = ";") %>%
  mutate(growth = (lbnppc_1996-lbnppc_1960)/(1996-1960)) %>%
  select(-lbnppc_2014, -skole_p_1996) %>%
  drop_na

# The basic regression. None of the variables are significant. 
reg1 <- lm(growth ~ lbnppc_1960 + gruve_1960, data = countries)

# Various summaries of the model (install the packages if you do not have them
# already).

library(stargazer)
library(jtools)
library(broom)

summary(reg1)                                   # Classic output
stargazer(reg1, type = "text")                  # Regression table, can be exported to html, latex, word
summ(reg1)                                      # Nice table, can also be exported.
plot_summs(reg1)                                # Plotting the estimated regression coeff and uncertainty
plot_summs(reg1, plot.distributions = TRUE)     # Adding the sampling distriburtions of the estimates
tidy(reg1)                                      # Regression output as tibble 

# Problem 5 -- Jackknife estimation ------

# The strategy here is to make a data frame in the same way as we did in the
# lecture, where we for each country store the data set *wihout* that particular
# country.


jackknife_coef <- 
  countries %>% 
  
  mutate(reg_data = map(land, \(x) x)) %>% 
  
  mutate(model = map(reg_data, 
                     \(x)
                     
                     lm(growth ~ lbnppc_1960 + gruve_1960)
                     
                     )) %>% 
  
  mutate(coeff = map(model, tidy)) %>% 
  
  unnest(coeff) %>% 
  
  select(landkode, land, term, estimate)


# Calculate the jackknife estimates of the coefficients:

jackknife_coef %>% 
  
  group_by(term) %>% 
  
  summarize(jackknife_estimate = mean(estimate))

# The jackknife estimates of the mining coefficient is approximately the same as
# the normal estimate. But by looking at the historam of the estimated mining
# coefficient we see something strange:
jackknife_coef %>% 
  
  filter(term == "gruve_1960") %>% 
  
  ggplot(aes(x = estimate)) +
  
  geom_histogram(binwidth =30)

# It looks like there is one country that completely drives the results. If we
# take out the single country, the estimated coefficient is strongly negative.
# Otherwise it is very positive. (Can you figure out what country that is and
# try to explain the results?)

# Problem 6 -- Jackknife estimation ------------

# Here are the possible variables
possible_variables <- c("skole_p_1960", "skole_h_1960", "gruve_1960", 
                        "olje_1960", "malaria_1960", "kapitalisme_1960")

# Try the functions combn to create all possible combinations of m elements
# drawn from a vector, here we set m = 3:
combn(possible_variables, m = 3, simplify = TRUE)

# Start by creating a simple data frame containing the numbers from 0 to 6,
# which are what we are looking to loop over in the combn-functionn:
estimates <- 
  tibble(n = 0:6) %>% 
  # We then map the combn-function to the n-column. Note that we do not writ the
  # helper function separately, we just define it directly in the map-fundtion.
  mutate(combinations = map(n, function(x) combn(possible_variables, 
                                                 m = x, 
                                                 simplify = FALSE))) %>% 
  # Unpack the combinations, giving us one entry per possible combination of the
  # variables.
  unnest(combinations) %>% 
  # We use the map function to add the final variable that should be present in
  # all of the regressions. We also need the response variable:
  mutate(combinations = map(combinations, 
                            function(x) c(x, "lbnppc_1960", "growth"))) %>% 
  # Make a new column with a version of the data set that has been subsetted
  # accoring to the character vector of variables in the combinations-column:
  mutate(reg_data = map(combinations, function(x) countries %>% select(x))) %>% 
  # Run the regression on all of the data sets:
  mutate(model = map(reg_data, function(x) lm(growth ~ ., data = x))) %>% 
  # Unpack like we did above:
  mutate(coeff = map(model, tidy)) %>% 
  unnest(coeff) %>% 
  # Select the estimates. We can keep more variables if we are interested in
  # looking more into which estimate comes from where. It is also advisable to
  # collect the standard deviations of the estimates in order to et an idea of
  # estimation uncertainty.
  select(term, estimate)

# Plot a histogram of all of the estimates of the initial wealth coefficients:
estimates %>% 
  filter(term == "lbnppc_1960") %>% 
  ggplot(aes(x = estimate)) +
  geom_histogram() +
  ylab("") + xlab("Estimate of the coefficient of 'lbnppc_1960'") +
  theme_bw()
