library(rnaturalearth)
library(ggplot2)
library(sf)
library(ggthemes)
library(dplyr)
library(geosphere)
head(ne_countries())


colnames(ne_countries())

countries <- ne_countries()

countries %>% 
  filter(region_un == "Asia") %>% 
  ggplot(aes(fill = pop_est/1000000)) +
  geom_sf(color = "black")+theme_map()
  
punkter <- data.frame(
  lon = c(5.7, 10), # longituder
  lat = c(60, 59.5)  # latituder
)

avstand  <- distm(punkter)/1000
km<- round(avstand[1,2])

# Konverter punktene til sf-objekt
punkter_sf <- st_as_sf(punkter, coords = c("lon", "lat"), crs = 4326)
line <- st_sfc(st_linestring(as.matrix(punkter)), crs = 4326)

line_sf <- st_sf(geometry = line) 
  
countries %>% 
  filter(region_un == "Europe") %>% 
  ggplot() +
  geom_sf()+
  geom_sf(data= punkter_sf)+
  geom_sf(data = line_sf,size = 1)

punkter <- data.frame(
  lon = c(5.7, 10), # longituder
  lat = c(60, 59.5)  # latituder
)

# Konverter punktene til sf-objekt
punkter_sf <- st_as_sf(punkter, coords = c("lon", "lat"), crs = 4326)
line <- st_sfc(st_linestring(as.matrix(punkter)), crs = 4326)

line_sf <- st_sf(geometry = line) 
  
countries %>% 
  filter(region_un == "Europe") %>% 
  ggplot() +
  geom_sf(fill = "lightblue")+
  geom_sf(data= punkter_sf)+
  geom_sf(data = line_sf,size = 1)+
coord_sf(xlim = c(0, 15),
         ylim = c(55,65))+
  labs(title = distm(punkter))+
  labs(title = paste0("Total distance is around ", km, " km"))+
  theme_map()

       
