# Exercises for the many models lesson.
# 

library(tidyverse)
library(readr)
library(tidymodels)
library(purrr)

countries <- 
  read_delim("growth.csv", delim = ";") %>%
  mutate(growth = (lbnppc_1996-lbnppc_1960)/(1996-1960)) %>%
  select(-lbnppc_2014, -skole_p_1996) %>%
  drop_na

# Jackknife_Coef ----------------------------------------------------------


jackknife_coef <- 
  countries %>% 
  
  #Map through all rows, and ignore the current country from df
  mutate(reg_data = map(land, \(x) filter(countries, land != x)),
         
         #Make a new col, with a linear model for each of the dfs. 
         model = map(reg_data, \(x)lm(growth ~ lbnppc_1960 + gruve_1960, data = x)),
         
         #Get the first coeffisient
         coeff = map(model, tidy)) %>% 
  
  #Unnest the coefficient
  unnest(coeff) %>%
  
  #Select only the neccecery terms
  select(landkode, land, term, estimate)
         
         
# Calculate the jackknife estimates of the coefficients:
jackknife_coef %>% 
  #All the terms
  group_by(term) %>% 
  #Mean of terms of the same type
  summarize(jackknife_estimate = mean(estimate))


jackknife_coef %>% 
  filter(term == "gruve_1960") %>% 
  ggplot(aes(x = estimate)) +
  geom_histogram()


#Finding the reason

possible_variables <- c("skole_p_1960", "skole_h_1960", "gruve_1960", 
                        "olje_1960", "malaria_1960", "kapitalisme_1960")


# drawn from a vector, here we set m = 3:
combn(possible_variables, m = 3, simplify = TRUE)

estimates <- 
  tibble(n = 0:6) %>% 

  mutate(combinations = map(n, function(x) combn(possible_variables, 
                                                 m = x, 
                                                 simplify = FALSE))) %>% 
  unnest(combinations) %>% 

  mutate(combinations = map(combinations, 
                            function(x) c(x, "lbnppc_1960", "growth"))) %>% 

  mutate(reg_data = map(combinations, function(x) countries %>% select(x))) %>% 
  mutate(model = map(reg_data, function(x) lm(growth ~ ., data = x))) %>% 
  mutate(coeff = map(model, tidy)) %>% 
  unnest(coeff) %>% 

  select(term, estimate)

estimates %>% 
  filter(term == "lbnppc_1960") %>% 
  ggplot(aes(x = estimate)) +
  geom_histogram() +
  ylab("") + xlab("Estimate of the coefficient of 'lbnppc_1960'") +
  theme_bw()
