library(rnaturalearth)
library(tidyverse)
library(dplyr)
library(tidyr)
library(ggthemes)

world <- ne_countries(scale = "medium", returnclass = "sf")

world %>% 
  ggplot(aes(fill=income_grp))+ #Making the aestetic fill based on income
  
  geom_sf()+ #Visualise geoms
  
  labs(title = "World Map",
       fill= "Income Grp")+
  scale_fill_viridis_d()+
  theme_map()+
  theme(legend.position = "right",
        legend.title = element_text(face="bold"),
        plot.title = element_text(size = 30,
                                  hjust = 0.5))
# Svalbard ----------------------------------------------------------------

world %>% 
  filter(region_un == "Europe") %>% 
  head()

# Filtering out Norway from World
world %>% filter(geounit=="Norway") %>% 
  
# Making the ggplot  
  ggplot(aes())+
  
# Using the geom sf to graph geometries  
  geom_sf(aes())+
  
# Setting the limits to the graph   
  coord_sf(x = c(10,33),
           y= c(76.7,80.4)) +
  
# Making a title for the graph
  labs(title = "Svalbard")+

#Making a theme map
  theme_map()+
  
# Adjusting the position of the title
  theme(title = 
          element_text(
            size = 25,
            hjust= 0.7,
            vjust = 0.4
          ),
        legend.title = 
          element_blank())

