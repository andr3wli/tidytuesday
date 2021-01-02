library(tidyverse)
library(patchwork)
library(ggtext)
library(extrafont)
library(maps)
library(usmap)
library(scales)
library(gghighlight)

beer_states <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-03-31/beer_states.csv')

#US map
states <- map_data("state")

#2019 on premise beer production
beer_data <- beer_states %>%
  filter(state != "total", year == '2019', type == "On Premises")

on_prem <- plot_usmap(data = beer_data, values = "barrels", labels = F) + 
  scale_fill_continuous(low = "#fff5f0", high = "#cb181d", 
                        name = "On-premise beer production (2019)", 
                        label = comma) + 
  guides(fill = guide_colorbar(barwidth = 20, barheight = 1.5, 
                               title.position = "top", title.hjust = 0.5)) +
  theme(legend.text = element_text(size=8, face = "bold"), 
        legend.title = element_text(size = 12, face="bold"),
        legend.position = "bottom")

#2019 bottle/cans production
can_data <- beer_states %>%
  filter(state != "total", year == "2019", type == "Bottles and Cans")

cans <- plot_usmap(data = can_data, values = "barrels", labels = F) + 
  scale_fill_continuous(low = "#f7fcf5", high = "#238b45", 
                        name = "Bottle/Can beer production (2019)", 
                        label = comma) + 
  guides(fill = guide_colorbar(barwidth = 20, barheight = 1.5, 
                               title.position = "top", title.hjust = 0.5)) +
  theme(legend.text = element_text(size=8, face = "bold"), 
        legend.title = element_text(size = 12, face="bold"),
        legend.position = "bottom")

#2019 keg data
keg_data <- beer_states %>%
  filter(state != "total", year == "2019", type == "Kegs and Barrels")

kegs <- plot_usmap(data = keg_data, values = "barrels", labels = F) + 
  scale_fill_continuous(low = "#f7fbff", high = "#2171b5", 
                        name = "Keg/Barrel beer production (2019)", 
                        label = comma) + 
  guides(fill = guide_colorbar(barwidth = 20, barheight = 1.5, 
                               title.position = "top", title.hjust = 0.5)) +
  theme(legend.text = element_text(size=8, face = "bold"), 
        legend.title = element_text(size = 12, face="bold"),
        legend.position = "bottom")

#Craft beers
#beer_data has the on premise beer data
craft <- beer_states %>%
  filter(state != "total", type == "On Premises", !is.na(barrels))

d <- craft %>%
  ggplot(aes(x = year, y = barrels, color = state)) +
  geom_line(aes(group = state), size = 1.3) +
  scale_colour_manual(values = c("#e41a1c","#377eb8", "#4daf4a", "#984ea3", "#ff7f00")) +
  gghighlight(max(barrels) > 163801) +
  scale_y_continuous(labels = comma) +
  scale_x_continuous(breaks = c(2009:2019)) +
  labs(x = "", y = "Number of barrels", 
       title = "More craft beer is being consumed on premise",
       subtitle = "Especially <strong><span style='color:#e41a1c;'>California </span></strong>") +
       # caption = "Source: Alcohol and Tobacco Tax and Trade Bureau (TTB)\nVisualization: Andrew Li") +
  theme_classic() +
  theme(plot.subtitle = element_markdown()) +
  theme(plot.title = element_text(face = "bold", size = 15))

ggsave(here::here("beer_production", "craft_beer.png"), dpi = 320, height = 6, width = 11)

# combining the map plots 
state_combined <-on_prem + cans + kegs + plot_annotation(
  title = "Which state produces the most beer?",
  caption = "Source: Alcohol and Tobacco Tax and Trade Bureau (TTB)\nVisualization: Andrew Li",
  theme = theme(plot.title = element_text(size = 15, face = "bold"))
)
ggsave(here::here("beer_production", "beer_maps.png"), dpi = 320, height = 5, width = 11)


# combine map and the other plot now
(on_prem + cans + kegs) / d + 
  plot_annotation(title = "Which state produces the most beer?",
                  caption = "Source: Alcohol and Tobacco Tax and Trade Bureau (TTB)\nVisualization: Andrew Li",
                  theme = theme(plot.title = element_text(size = 15, face = "bold")))
ggsave(here::here("beer_production", "combine_all.png"), dpi = 320, height = 7, width = 16)
