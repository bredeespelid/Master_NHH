# EXAM -- BAN400 -- FALL 2024
# 
# Enter your answers to the questions in this file. When you are done, you will
# hand in this script and *nothing else*. You can assume that the grader has the
# same folder structure as provided in the zip-file attached to the exam.


# Install the here package and other librarys -----------------------------

install.packages("here")

library(here)
library(readr)
library(dplyr)
library(tidyr)

# Problem a ---------------------------------------------------------------

#Fetch turbines data from the data folder
turbines <- read_csv(here("data","ban400-h24-turbines.csv" ))

#Check the structure
str(turbines)

#Fetch models data from the data folder
models <- read_csv(here("data","ban400-h24-models.csv" ))

#Check the structure
str(models)

#Grouped turbines into locations and amount of models at each location
#and the capacity of each model

#The turbines dataset contained the capacity but to utilize the both
#we inner join them
joined <- inner_join(turbines, models, by= "model")

#First select relevant columns, then group them into smaller parts,
# ant get the amount of each subpart
joined %>% 
  select(location, model, capacity.y) %>% 
  group_by(location, model, capacity.y) %>% 
  summarise(Amount = n())

# Problem b ---------------------------------------------------------------
library(lubridate)
library(forcats)
library(ggplot2)
library(ggthemes)

#Load in the csv
wind <- read_csv(here("data","ban400-h24-wind.csv" ))
#Check structure
str(wind)

#First of by looking at the structure the time column isnt a datetime object
wind <-  wind %>% 
  
  #Mutate the colummn to change type
   mutate(time = dmy_hm(time))

#Lets bring the names to factors so we only get 3 leveles
wind <-wind %>% 
  
  #Mutate the colummn to change type
  mutate(name = as_factor(name))

#Finished plot with wsj theme
wind %>% 
  #Set the axis, and give color
  ggplot(aes(x = time, y= mean_wind, color = name))+
  
  #Set the line size
  geom_line(size= 0.4) +
  
  #Wallstreet journal style
  theme_wsj() +
  
  #Give labs
  labs(title = "Mean wind per location")+
  
  #Give title
  theme(legend.title = element_text("Locations"))
  
# Problem c ---------------------------------------------------------------
library(purrr)

#First we need to make a new table with the given data
model <- c("AF-1500", "V-2000", "SP-2500")
W_cut <- c(4.0, 4.0, 3.0)
W_rated <- c(13.0, 11.4, 10.8)
W_cutout <- c(25.0,25.0,25.0)

#Then we make them into a dataframe
powers <-  as.data.frame(cbind(model, W_cut, W_rated, W_cutout))

#Then we add them to the turbine-models dataset called joined
problem_c <- inner_join(joined, powers, by="model")
str(problem_c)

#Gives the wind dataset a new column so we can match the sets
wind <- wind %>% 
  mutate(location = name)

#now this is a big dataset, so i will make it smaller just for testing
new_problem_c <- inner_join(wind, problem_c, by = "location")

#First make the turbine parameters to the right format
new_problem_c<- new_problem_c %>% 
  mutate(W_cut = as.double(W_cut),
  W_rated = as.double(W_rated),         
  W_cutout = as.double(W_cutout)       
         )

#Test_set of the last 10 rows
test_c <-tail(new_problem_c, 10) %>% 
  as.data.frame()

test_c <-test_c %>% 
  mutate(index = 1:nrow(test_c))

str(test_c)

#Ignore this part for now___________________
#Function with map / just to get an idea
test_c %>% 
  mutate(
    Power = 
      map(index, \(x)
          
          #First if
          ifelse(mean_wind[x]<W_cut[x], #
                 #True
                 0, 
                 
                 #False (new if)
                 ifelse( W_cut[x] <=mean_wind[x] & mean_wind[x] < W_rated,#
                         #True
                         ((mean_wind[x]-W_cut[x])/(W_rated[x]-W_cut[x]))^3,
                         
                         #False new_IF
                         ifelse(
                           W_rated[x]<= mean_wind[x] & mean_wind[x]< W_cutout[x],
                           #True given that p-rated is the same
                           ((mean_wind[x]-W_cut[x])/(W_rated[x]-W_cut[x]))^3,
                           
                           #False
                           ifelse(mean_wind[x]>=W_cutout, 0,0)
                             
                                     )
                              )
                         )
                 )
          )

#___________________


#Vector of windspeed
windspeed_v <- c(1,2,3,4,5)

#Function for the model AF-1500

ws_f <- function(windspeed){
  #First if
  ifelse(windspeed<4.0, #
         #True
         0, 
         
         #False (new if)
         ifelse( 4.0 <=windspeed & windspeed < 13.0,#
                 #True
                 ((windspeed-4.0)/(13.0-4.0))^3,
                 
                 #False new_IF
                 ifelse(
                   13.0<= windspeed & windspeed< 25.0,
                   #True given that p-rated is the same
                   ((windspeed-4.0)/(13.0-4.0))^3,
                   
                   #False
                   ifelse(windspeed>=25.0, 0,0)
                 )  ))                
}


#Output seems to checkout
ws_f(windspeed_v)
  
# Problem e ---------------------------------------------------------------

#Task_1

#making a new vector 1-30
windspeed_v <- 1:30

#running it in the function
ws_f(windspeed_v)

#This seems right so lets plot it!
power_outage <- ws_f(windspeed_v)

#Merging the data together
new_df <- cbind(windspeed_v, power_outage) %>% 
  as.data.frame()

#Checking to see if the structure is right
str(new_df)

new_df %>% 
  #Making power as a function of windspeed
  ggplot(aes(x = windspeed_v, y=power_outage))+
  
  #Making a geom line
  geom_line()+
  
  #minimal theme
  theme_minimal()+
  
  #Fitting title
  labs(title = "Power-Outage for AF-1500")


#Task_2 

#Make a test vector 1-30
Testing <- 1:30

#Making a dataframe for all the models
All_models<- Testing %>% 
  
  #Making it as tibble
  as_tibble() %>% 
  #Adding names
  mutate(Model = "AF-1500",
         Model2 = "V-2000",
         Model3 = "SP-2500") %>% 
  pivot_longer(cols = starts_with("Model"),
               values_to = "x") %>% 
  select(-name) %>% 
  mutate(model = x) %>% 
  mutate(mean_wind = value)
  


#Joins the dataframes
all_models_p <- inner_join(All_models, powers, "model") 

#Makes an index for help in the map function later
all_models_p<- all_models_p %>% mutate(index = 1:nrow(all_models_p))

#Changing format
all_models_p<- all_models_p %>% 
  mutate(
    W_cut = as.double(W_cut),
    W_rated = as.double(W_rated),
    W_cutout = as.double(W_cutout)
  )

#Checking colnames
colnames(all_models_p)

#Lets make functions for all of the models with purrr
#This function loops through an index so we can fetch each value from each row
All_mod_2 <- all_models_p %>% 
  mutate(
    Power = 
      map(index, \(x)
          
          #First if
          ifelse(mean_wind[x]<W_cut[x], #
                 #True
                 0, 
                 
                 #False (new if)
                 ifelse( W_cut[x] <=mean_wind[x] & mean_wind[x] < W_rated[x],#
                         #True
                         ((mean_wind[x]-W_cut[x])/(W_rated[x]-W_cut[x]))^3,
                         
                         #False new_IF
                         ifelse(
                           W_rated[x]<= mean_wind[x] & mean_wind[x]< W_cutout[x],
                           #True given that p-rated is the same
                           ((mean_wind[x]-W_cut[x])/(W_rated[x]-W_cut[x]))^3,
                           
                           #False
                           ifelse(mean_wind[x]>=W_cutout[x], 0,0)
                           
                         )
                 )
          )
      )
  ) %>% unnest(Power)

All_turbines_plot <- All_mod_2 %>% 
  #Making power as a function of windspeed
  ggplot(aes(x = mean_wind, y=Power))+
  
  #Making a geom line
  geom_col() +
  
  #Making each model to a factor with three levels and graphing them
  facet_wrap(as_factor(model)~.)+
  
  #Going minimal again
  theme_minimal()+
  
  #Making lab titles
  labs(
    
    x="Wind Speed",
    y="Power Outage",
    title = "Power-Outage for each Turbine Model"
  )
All_turbines_plot 

# Problem f ----------------------------------------------------------------

first_join <- inner_join(turbines, powers, by="model")

#Giving wind an hour column 
wind_h <- wind %>% 
  mutate(date = time,
    time = hour(time),
    location = name)

second_join <-inner_join(wind_h, first_join, by = "location", relationship = "many-to-many")



# Problem g ---------------------------------------------------------------

#Checking if the values seems reasonable
second_join %>% 
  filter(name == "Kappstad") %>% 
  group_by(time) %>% 
  summarise(meann = mean(mean_wind))

#Giving it an index
all_turbines<- second_join %>% mutate(index = 1:nrow(second_join))

#Making them into correct format
all_turbines<- all_turbines %>% 
  mutate(
    W_cut = as.double(W_cut),
    W_rated = as.double(W_rated),
    W_cutout = as.double(W_cutout),
    time = as_factor(time)
  )

#Checking the structure
str(all_turbines)

#Checking the col names
colnames(all_turbines)

#Going over all the columns
all_turbines <- all_turbines %>% 
  mutate(
    Power = 
      map(index, \(x)
          
          #First if
          ifelse(mean_wind[x]<W_cut[x], #
                 #True
                 0, 
                 
                 #False (new if)
                 ifelse( W_cut[x] <=mean_wind[x] & mean_wind[x] < W_rated[x],#
                         #True
                         ((mean_wind[x]-W_cut[x])/(W_rated[x]-W_cut[x]))^3,
                         
                         #False new_IF
                         ifelse(
                           W_rated[x]<= mean_wind[x] & mean_wind[x]< W_cutout[x],
                           #True given that p-rated is the same
                           ((mean_wind[x]-W_cut[x])/(W_rated[x]-W_cut[x]))^3,
                           
                           #False
                           ifelse(mean_wind[x]>=W_cutout[x], 0,0)
                           
                         )
                 )
          )
      )
  ) %>% 
  unnest(Power)

#Rounding the power to not have digets
all_turbines<- all_turbines %>% 
  mutate(
    Power = round(Power,2)
  ) 



##Part 1 ------------------------------------------------------------------

#

#First grouping then graphing part 1.
all_turbines %>% 
  group_by(time, location, model, capacity) %>% 
  summarise(Total_Power = sum(Power)*capacity) %>% 
  ggplot(
    aes(x = time, y = Total_Power)
  )+
  geom_col()+
  facet_grid(location ~.)+
  theme_minimal()

#As we can see in this graph kvernes makes the most Power is Kvernes

##Part 2 ------------------------------------------------------------------

summary_table<- all_turbines %>% 
  group_by(time, location, model) %>% 
  summarise(
            mean_h = mean(Power)) %>% 
  ungroup()

#Here we can see that the mean power outage is a bit more flatten out
summary(summary_table)

##Part 3  -----------------------------------------------------------------
all_turbines_m <- all_turbines %>% 
  mutate(yearr = year(date),
         monthh = as_factor(month(date)))

monthly_table <- all_turbines_m %>% 
  group_by(monthh, location, model) %>% 
  summarise(
    Sum_P = sum(Power)) %>% 
  ungroup()

summary(monthly_table)

# Problem h ------------------------------------------------------------------

#Checking the amount of turbins at each location
turbines %>% 
  group_by(location) %>% 
  summarise(n = n())

#Checking the data we have found
summary_table
monthly_table

#Based on the data gathered and the statement "Wind is everywhere,
#so the placement of land-based wind farms should be mostly based on conveniece:
#out-of-sight, out-of-mind. 

#Wind is not everywhere, so thats the first indication on why its wrong.
#in our case Kappstad, which produces very little power compared to the others
#and they have the same amount of turbines as Kvernes. So Yes, if one was to build
#a wind turbine it should be out of sight, but there is not wind everywhere. for
#it the be beneficial. 

# Problem i ------------------------------------------------------------------

#Based on the plot from earlier we can see what turbines that is effective
#at the different wind levels, W_cut out will not do anything because it
#drops on every level
All_turbines_plot


#Making the data frame with all the models

first_join <- inner_join(turbines, powers, by="model")

#Giving wind an hour column 
wind_h <- wind %>% 
  mutate(date = time,
         time = hour(time))

second_join <-inner_join(wind_h, first_join, by = "location", relationship = "many-to-many")

#Checking if the values seems reasonable
second_join %>% 
  filter(name == "Kappstad") %>% 
  group_by(time) %>% 
  summarise(meann = mean(mean_wind))

#Giving it an index
all_turbines_i<- second_join %>% mutate(index = 1:nrow(second_join))
#Making them into correct format
all_turbines_i<- all_turbines %>% 
  mutate(
    W_cut = as.double(W_cut),
    W_rated = as.double(W_rated),
    W_cutout = as.double(W_cutout),
    time = as_factor(time)
  )
#Checking the structure
str(all_turbines_i)
#Checking the col names
colnames(all_turbines_i)

Parameter_1<- all_turbines_i %>% 
  mutate(W_cut = W_cut*0.9)
Parameter_1


#Going over all the columns
Parameter_1_Power <- Parameter_1 %>% 
  mutate(
    Power = 
      map(index, \(x)
          
          #First if
          ifelse(mean_wind[x]<W_cut[x], #
                 #True
                 0, 
                 
                 #False (new if)
                 ifelse( W_cut[x] <=mean_wind[x] & mean_wind[x] < W_rated[x],#
                         #True
                         ((mean_wind[x]-W_cut[x])/(W_rated[x]-W_cut[x]))^3,
                         
                         #False new_IF
                         ifelse(
                           W_rated[x]<= mean_wind[x] & mean_wind[x]< W_cutout[x],
                           #True given that p-rated is the same
                           ((mean_wind[x]-W_cut[x])/(W_rated[x]-W_cut[x]))^3,
                           
                           #False
                           ifelse(mean_wind[x]>=W_cutout[x], 0,0)
                           
                         )
                 )
          )
      )
  ) %>% 
  unnest(Power)

Output_P1 <- Parameter_1_Power %>% 
  summarise(Power_1 = sum(Power))


Parameter_2 <- all_turbines_i
#Going over all the columns
Parameter_2_Power <- Parameter_2 %>% 
  mutate(
    Power = 
      map(index, \(x)
          
          #First if
          ifelse(mean_wind[x]<W_cut[x], #
                 #True
                 0, 
                 
                 #False (new if)
                 ifelse( W_cut[x] <=mean_wind[x] & mean_wind[x] < W_rated[x],#
                         #True
                         1.1*((mean_wind[x]-W_cut[x])/(W_rated[x]-W_cut[x]))^3,#Changes
                         
                         #False new_IF
                         ifelse(
                           W_rated[x]<= mean_wind[x] & mean_wind[x]< W_cutout[x],
                           #True given that p-rated is the same
                           1.1*((mean_wind[x]-W_cut[x])/(W_rated[x]-W_cut[x]))^3,#Changes
                           
                           #False
                           ifelse(mean_wind[x]>=W_cutout[x], 0,0)
                           
                         )
                 )
          )
      )
  ) %>% 
  unnest(Power)


#Rounding the power to not have digets
all_turbines<- all_turbines %>% 
  mutate(
    Power = round(Power,2)
  ) 

Output_P2<- Parameter_2_Power %>% 
  summarise(Power_2 = sum(Power))


Parameter_3<- all_turbines_i %>% 
  mutate(W_cutout = W_cutout*1.1)


#Going over all the columns
Parameter_3_Power <- Parameter_3 %>% 
  mutate(
    Power = 
      map(index, \(x)
          
          #First if
          ifelse(mean_wind[x]<W_cut[x], #
                 #True
                 0, 
                 
                 #False (new if)
                 ifelse( W_cut[x] <=mean_wind[x] & mean_wind[x] < W_rated[x],#
                         #True
                         ((mean_wind[x]-W_cut[x])/(W_rated[x]-W_cut[x]))^3,#Changes
                         
                         #False new_IF
                         ifelse(
                           W_rated[x]<= mean_wind[x] & mean_wind[x]< W_cutout[x],
                           #True given that p-rated is the same
                           ((mean_wind[x]-W_cut[x])/(W_rated[x]-W_cut[x]))^3,#Changes
                           
                           #False
                           ifelse(mean_wind[x]>=W_cutout[x], 0,0)
                           
                         )
                 )
          )
      )
  ) %>% 
  unnest(Power)

Output_P3 <- Parameter_3_Power %>% 
  summarise(Power_3 = sum(Power))

#The total power production would benefit the most from parameter 2! 
cbind.data.frame(Output_P1, Output_P2, Output_P3)

#Given the graph we made earlier we spotted that the model
#SP-2500 is the most efficient, and supported by Table 1 in the question,
#This would benefit the most for an increase in P_rated. 

#Didnt have time to thake capacity into account..




