# Data source: https://ourworldindata.org/grapher/unemployment-rate

setwd("E:/Data science/Projects/Europe employment")

# Loading packages
library('rnaturalearthdata')
library('tidyverse')
library('sf')
library('rnaturalearth')
library('transformr')
library(gganimate)

# Loading unemployment data
unemployment <- read.csv("unemployment-rate.csv", header = TRUE)
unemployment <- rename_with(unemployment, tolower)
unemployment<-unemployment[!(is.na(unemployment$code) | unemployment$code==""), ]
view(unemployment)

# World data 
world <- ne_countries(scale = 'medium', returnclass = 'sf')

## Joining data
countries3 <- left_join(world, unemployment, by =c('iso_a3'='code'))
countries3 <- with(countries3, countries3[!(year == "" | is.na(year)), ])


# Animating 
myPlot <- world %>%
              st_transform(crs = '+proj=robin') %>%
              ggplot()+
              geom_sf()+
              geom_sf(data = countries3, aes(fill = unemploymentrate))+
              scale_fill_gradient(low = "turquoise", high = "#030303", na.value = "gray87")+
              theme_minimal()+
              labs(title = 'Year: {frame_time}') +
              transition_time(year) +
              ease_aes('linear')

animate(myPlot, duration = 8, fps = 30, width = 1800, height = 1000, renderer = gifski_renderer())
anim_save("final3.gif")