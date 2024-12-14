# Next example: Using official data. You need to download this yourself. 
# Check layers
st_layers(here("data", "municipalities", "Kommuner.geojson"))

# Read data
munic <- 
  st_read(here("data", "municipalities", "Kommuner.geojson"),
          layer = "Kommuner") %>% 
  st_transform(crs = crs)

munic

# Plot the data
munic %>% 
  ggplot(aes(geometry = geometry)) +
  geom_sf()+
  coord_sf(xlim = c(4, 15), ylim = c(58, 65))
