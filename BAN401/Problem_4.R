library(tidyverse) #for using tibble and pipes 

#data frame for the routes data 
df <- tibble(route = c("City A -> B", "City B -> C", "City A -> C"),
            distance = c(350, 500, 700),
            ferries = c(1, 2, 3),
            tolls = c(3, 5, 6)
            )
#list of cost data 
electric <- list(0.20, 180, 40)
diesl <- list(1.5, 300, 80)


#Calculate the savings
calc <- df %>% 
  mutate(et_total = distance * electric[[1]] + ferries * electric[[2]] + tolls * electric[[3]],
         dt_total = distance * diesl[[1]] + ferries * diesl[[2]] + tolls * diesl[[3]],
         savings = dt_total - et_total)

#display of results
calc
