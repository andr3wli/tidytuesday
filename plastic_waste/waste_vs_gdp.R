library(tidyverse)
library(ggimage)
library(extrafont)
library(patchwork)
theme_set(theme_classic())

waste_vs_gdp <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-05-21/per-capita-plastic-waste-vs-gdp-per-capita.csv")
waste_vs_gdp <- janitor::clean_names(waste_vs_gdp)

waste_vs_gdp_plot <- waste_vs_gdp %>%
  rename(percap_waste = per_capita_plastic_waste_kilograms_per_person_per_day) %>% 
  filter(entity != "World" & year == 2010) %>% 
  top_n(20, percap_waste) %>%
  mutate(bar = map2(0.05, percap_waste, seq, by = 0.09)) %>% 
  unnest(bar) %>%
  mutate(plastic = sample(c("https://cdn1.iconfinder.com/data/icons/fitness-icon-collection/100/plastic-128.png",
                            "https://image.flaticon.com/icons/png/128/81/81940.png",
                            "https://image.flaticon.com/icons/png/128/1758/1758890.png",
                            "https://image.flaticon.com/icons/png/128/85/85051.png",
                            "https://image.flaticon.com/icons/png/128/1718/1718442.png",
                            "https://image.flaticon.com/icons/png/128/960/960773.png"),
                          size =  nrow(.), replace = TRUE),
         angle = runif(nrow(.), 0, 360)) %>%
  ggplot(aes(fct_reorder(factor(entity), percap_waste), bar*1000, angle = angle)) +
  geom_image(aes(image = plastic), color = "#93bc3f", size = 0.04) +
  coord_flip() +
  labs(x = "", 
       y = "")
  # theme(
  #   plot.title = element_text(face = "bold", size = 13)
  # )

ggsave(here::here("plastic_waste", "waste_vs_gdp.png"), dpi = 320, height = 6, width = 11)


img_pc_combined <- mismanaged_plot + waste_vs_gdp_plot
img_pc_combined + plot_annotation(
  title = "<strong>Plastic pollution - Top 20 countries with the most <span style='color:royalblue1;'>relative</span> and 
  <span style='color:#93bc3f;'>absolute</span> plastic waste </strong>",
  subtitle = "grams per person per day (2010)",
  caption = "Data: OurWorldinData.org | Visualization: Andrew Li",
  theme = theme(plot.title = element_markdown(lineheight = 1.1))
)

ggsave(here::here("plastic_waste", "combined_pc.png"), dpi = 320, height = 5, width = 13)
ggsave(here::here("plastic_waste", "img_combined.png"), dpi = 320, height = 4, width = 11)


#bar plot
waste_vs_gdp %>%
  rename(percap_waste = per_capita_plastic_waste_kilograms_per_person_per_day) %>% 
  filter(entity != "World" & year == 2010) %>% 
  top_n(20, percap_waste) %>%
  ggplot(aes(fct_reorder(factor(entity), percap_waste), percap_waste*1000)) +
  geom_col(width = 0.7, fill = "#93bc3f") +
  coord_flip() +
  labs(x = "", y = "Plastic waste per capita in grams")
