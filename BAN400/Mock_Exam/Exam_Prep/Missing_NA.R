library(nycflights13)
library(dplyr)
library(furrr)
library(purrr)
library(Amelia)

#Findings are that there is useually NA, values in the first 6 columns,
#Given the significent of the missing values based on the dataset there would
#Be no reason to replace them,rather remove them

flights %>% 
  filter(is.na(air_time))

flight <- flights

flights <- flights %>%
  group_by(tailnum) %>%
  mutate(
    air_time = if_else(
      
      is.na(air_time),
      
      if (all(is.na(air_time))) NA_real_
      
      else mean(air_time / distance, na.rm = TRUE) * distance,
      air_time
    )
  ) %>%
  ungroup() %>% 
  na.omit()

anyNA(flights$air_time)


missmap(flights)

# Wicked for loop ---------------------------------------------------------
means <- flights %>% 
  group_by(tailnum) %>% 
  na.omit() %>% 
  summarise(Avg_time = mean(air_time/distance))


test <- map(test_f$air_time, \(x)
    for(i in 1:nrow(test_f)){
     
      y<- means %>% 
        filter(tailnum == flight$tailnum[i]) %>% 
        as.data.frame()
      
      if_else(
       is.na(x),y[,2],x)

    }
    )
