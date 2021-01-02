library(tidyverse)
library(ggimage)
library(extrafont)
library(ggtext)
theme_set(theme_classic())

# I am borrowing heavily from Georgios Karamanis and his amazing work on this weeks data set. 

mismanaged_vs_gdp <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-05-21/per-capita-mismanaged-plastic-waste-vs-gdp-per-capita.csv")
mismanaged_vs_gdp <- janitor::clean_names(mismanaged_vs_gdp)

mismanaged_plot <- mismanaged_vs_gdp %>%
  rename(percap_mismanaged = per_capita_mismanaged_plastic_waste_kilograms_per_person_per_day) %>% 
  filter(entity != "World" & year == 2010) %>% 
  top_n(20, percap_mismanaged) %>% 
  mutate(bar = map2(0.01, percap_mismanaged, seq, by = 0.008)) %>% 
  unnest(bar) %>% 
  mutate(plastic = sample(c("https://cdn1.iconfinder.com/data/icons/fitness-icon-collection/100/plastic-128.png",
                            "https://image.flaticon.com/icons/png/128/81/81940.png",
                            "https://image.flaticon.com/icons/png/128/1758/1758890.png",
                            "https://image.flaticon.com/icons/png/128/85/85051.png",
                            "https://image.flaticon.com/icons/png/128/1718/1718442.png",
                            "https://image.flaticon.com/icons/png/128/960/960773.png"),
                          size =  nrow(.), replace = TRUE),
         angle = runif(nrow(.), 0, 360)) %>%
  ggplot(aes(fct_reorder(factor(entity), percap_mismanaged), bar*1000, angle = angle)) +
  geom_image(aes(image = plastic), color = "royalblue1", size = 0.04) +
  coord_flip() +
  scale_y_continuous(limits = c(0, 330), expand = c(0, 0)) +
  labs(x = "", 
       y = "")
  # theme(
  #   plot.title = element_text(face = "bold", size = 13)
  # )

ggsave(here::here("plastic_waste", "mismanaged_vs_gdp.png"), dpi = 320, height = 6, width = 11)



#bar plot for mismanaged plastic
bar_mismanaged <- mismanaged_vs_gdp %>%
  rename(percap_mismanaged = per_capita_mismanaged_plastic_waste_kilograms_per_person_per_day) %>% 
  filter(entity != "World" & year == 2010) %>% 
  top_n(20, percap_mismanaged) %>%
  ggplot(aes(fct_reorder(factor(entity), percap_mismanaged), percap_mismanaged*1000)) +
  geom_col(width = 0.7, fill = "royalblue1") +
  coord_flip() +
  labs(x = "", y = "Mismanaged plastic waste\nper capita in grams")
  
#bar plot for total plastic waste
bar_total <- waste_vs_gdp %>%
  rename(percap_waste = per_capita_plastic_waste_kilograms_per_person_per_day) %>% 
  filter(entity != "World" & year == 2010) %>% 
  top_n(20, percap_waste) %>%
  ggplot(aes(fct_reorder(factor(entity), percap_waste), percap_waste*1000)) +
  geom_col(width = 0.7, fill = "#93bc3f") +
  coord_flip() +
  labs(x = "", y = "Plastic waste per\ncapita in grams")

 bar_mismanaged + bar_total 

 
combined_bar <- bar_mismanaged + bar_total
combined_bar + plot_annotation(
  title = "<strong>Plastic pollution - Top 20 countries with the most <span style='color:royalblue1;'>relative</span> and 
  <span style='color:#93bc3f;'>absolute</span> plastic waste </strong>",
    subtitle = "grams per person per day (2010)",
    caption = "Data: OurWorldinData.org | Visualization: Andrew Li",
  theme = theme(plot.title = element_markdown(lineheight = 1.1))
)

ggsave(here::here("plastic_waste", "bar_combined.png"), dpi = 320, height = 4, width = 11)



