library(tidyverse)
library(datateachr)
library(scales)
theme_set(theme_classic())

#EDA: what are the most common tree species and locations with trees in Vancouver?
vt <- vancouver_trees
vt %>%
  count(genus_name, sort = TRUE) 
vt %>% 
  count(neighbourhood_name, sort = TRUE)

#visualize the most common tree species Vancouver:
#top 20 most common
vt %>%
  count(genus_name, sort = TRUE) %>%
  head(20) %>%
  mutate(genus_name = fct_reorder(genus_name, n)) %>%
  ggplot(aes(x = n, y = genus_name)) +
  geom_col() +
  labs(x = "", y = "", title = "Most common tree species in Vancouver") 

#top 10 most common
vt %>%
  count(genus_name, sort = TRUE) %>%
  head(10) %>%
  mutate(genus_name = fct_reorder(genus_name, n)) %>%
  ggplot(aes(x = n, y = genus_name)) +
  geom_col() +
  labs(x = "", y = "", title = "Most common tree species in Vancouver")

#visualize the location with the most trees in Vancouver:
vt %>%
  count(neighbourhood_name, sort = TRUE) %>%
  mutate(neighbourhood_name = fct_reorder(neighbourhood_name, n)) %>%
  ggplot(aes(x = n, y = neighbourhood_name)) +
  geom_col() +
  labs(x = "", y = "", title = "Neighbourhoods with the most tress in Vancouver")

#visualize the 10 most common type of trees in some of the most recognizable Vancouver neighborhoods
vt %>%
  mutate(genus_name = fct_lump(genus_name, n = 5)) %>%
  count(genus_name, sort = TRUE)
vt %>%
  mutate(neighbourhood_name = fct_lump(neighbourhood_name, n = 20)) %>%
  count(neighbourhood_name, sort = TRUE)
vt %>%
  count(genus_name, neighbourhood_name, sort = TRUE) %>%
  mutate(genus_name = fct_lump(genus_name, n = 5),
         neighbourhood_name = fct_lump(neighbourhood_name, n = 20)) %>%
  mutate(neighbourhood_name = fct_reorder(neighbourhood_name, n, sum)) %>%
  filter(genus_name %in% c("ACER", "PRUNUS", "FRAXINUS", "TILIA", "QUERCUS", "CARPINUS", "FAGUS",
                           "MALUS", "MAGNOLIA", "CRATAEGUS")) %>%
  ggplot(aes(x = n, y = neighbourhood_name, fill = genus_name)) +
  geom_col() +
  labs(x = "", y = "", title = "Top 10 most common tree species in Vancouver neighbourhoods", fill = "") +
  theme(plot.title = element_text(hjust = 0.6)) +
  scale_fill_manual(values=c("#8dd3c7", "#fccde5", "#bebada", "#ffffb3", "#80b1d3", "#fdb462",
                             "#b3de69", "#fb8072", "#d9d9d9", "#bc80bd"))
ggsave(here::here("trees", "trees1.png"), dpi = 320, height = 6, width = 11)


#trying out geom_point
vt %>%
  count(genus_name, neighbourhood_name, sort = TRUE) %>%
  mutate(genus_name = fct_lump(genus_name, n = 5),
         neighbourhood_name = fct_lump(neighbourhood_name, n = 20)) %>%
  mutate(neighbourhood_name = fct_reorder(neighbourhood_name, n, sum)) %>%
  filter(genus_name %in% c("ACER", "PRUNUS", "FRAXINUS", "TILIA", "QUERCUS", "CARPINUS", "FAGUS",
                           "MALUS", "MAGNOLIA", "CRATAEGUS")) %>%
  ggplot(aes(x = n, y = neighbourhood_name, color = genus_name)) +
  geom_point() +
  labs(x = "", y = "", title = "Top 10 most common tree species in Vancouver neighbourhoods", color = "") +
  theme(plot.title = element_text(hjust = 0.6)) +
  scale_color_manual(values=c("#8dd3c7", "#fccde5", "#bebada", "#ffffb3", "#80b1d3", "#fdb462",
                              "#b3de69", "#fb8072", "#d9d9d9", "#bc80bd"))
ggsave(here::here("trees", "trees_point.png"), dpi = 320, height = 6, width = 11)


#I want to make a plot via facet wrap because it'll be easier to see
vt %>%
  count(genus_name, neighbourhood_name, sort = TRUE) %>%
  mutate(genus_name = fct_lump(genus_name, n = 5),
         neighbourhood_name = fct_lump(neighbourhood_name, n = 20)) %>%
  mutate(genus_name = fct_reorder(genus_name, n, sum)) %>%
  filter(genus_name %in% c("PRUNUS", "FRAXINUS", "TILIA", "QUERCUS", "CARPINUS", "FAGUS",
                           "MALUS", "MAGNOLIA", "CRATAEGUS","ACER")) %>%
  filter(neighbourhood_name %in% c("RENFREW-COLLINGWOOD", "KENSINGTON-CEDAR COTTAGE", "HASTINGS-SUNRISE",
                                   "DUNBAR-SOUTHLANDS", "SUNSET", "KITSILANO", "VICTORIA-FRASERVIEW", "SHAUGHNESSY", "KERRISDALE")) %>%
  ggplot(aes(x = n, y = genus_name, fill = genus_name)) +
  geom_col() +
  labs(x = "", y = "", title = "Top 10 most common tree species in Vancouver neighbourhoods") +
  theme(plot.title = element_text(hjust = 0.6),
        legend.position = "none") +
  scale_fill_manual(values=c("#bebada", "#fdb462", "#b3de69", "#ffffb3",
                             "#fccde5", "#d9d9d9", "#bc80bd", "#80b1d3", "#fb8072", "#8dd3c7")) +
  facet_wrap(~neighbourhood_name)
ggsave(here::here("trees", "trees_facet.png"), dpi = 320, height = 6, width = 11)


#What is the distribution of the tree diameter? 
range(vt$diameter)
vt %>% 
  count(diameter, sort = TRUE)
vt %>%
  filter(diameter > 1) %>%
  ggplot(aes(diameter)) +
  geom_histogram(alpha = 0.7, color = "black")+
  xlim(0, 50) +
  geom_vline(aes(xintercept = mean(diameter)), color = "blue", linetype = "dashed") +
  #scale_x_log10(comma_format()) +
  labs(x = "", y = "", title = "Diameter distribution of Vancouver trees")
