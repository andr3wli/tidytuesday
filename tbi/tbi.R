library(tidyverse)
library(ggtext)
library(patchwork)

tbi_age <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-03-24/tbi_age.csv')


tbi_colors <- c("Assault",
                "Intentional self-harm",
                "Motor Vehicle Crashes",
                "Other unintentional injury, mechanism unspecified",
                "Unintentional Falls",
                "Unintentionally struck by or against an object")

names(tbi_colors) <- c("#1b9e77", "#d95f02", "#7570b3", "#e7298a", "#66a61e", "#e6ab02")

tbi_age_tidy <- tbi_age %>% 
  filter(age_group != "0-17" & age_group != "Total" & injury_mechanism != "Other or no mechanism specified") %>% 
  na.omit() %>%
  mutate(pct = number_est/sum(number_est)) %>%
  mutate(pct = pct * 10) %>%
  mutate(age_group = factor(age_group),
         injury_mechanism = factor(injury_mechanism),
         type = factor(type)) %>%
  mutate(age_group = fct_relevel(age_group, c("0-4", "5-14", "15-24",
                                              "25-34", "35-44", "45-54",
                                              "55-64", "65-74", "75+")))

tbi_age_tidy %>%
  filter(type == "Emergency Department Visit") %>%
  ggplot(aes(x = age_group, y = pct, color = injury_mechanism)) +
  geom_point() +
  geom_path(aes(group = 1)) +
  geom_hline(yintercept = 0, color = "black", size = 0.7) +
  facet_wrap(~injury_mechanism, scales = "free_y") +
  theme_minimal() +
  theme(legend.position = "none") +
  # scale_y_continuous(labels = scales::percent)
  scale_y_continuous(breaks = scales::breaks_pretty(n = 5, min.n = 5),
                     labels = scales::label_percent(accuracy = 0.1)) +
  scale_color_manual(values = names(tbi_colors))


visits <- tbi_age_tidy %>%
  filter(type == "Emergency Department Visit") %>%
  ggplot(aes(x = age_group, y = pct, color = injury_mechanism)) +
  geom_point() +
  geom_path(aes(group = injury_mechanism)) +
  geom_hline(yintercept = 0, color = "black", size = 0.3) +
  theme_minimal() +
  theme(legend.position = "bottom",
        plot.title = element_markdown(),
        plot.subtitle = element_markdown(),
        axis.text = element_text(face = "bold")) +
  scale_y_continuous(breaks = scales::pretty_breaks(n = 5, min.n = 5),
                     labels = scales::label_percent(accuracy = 1)) +
  scale_color_manual(values = names(tbi_colors)) +
  labs(x = "", y = "", color = "",
       title = "<strong> Leading causes of traumatic brain injury<br> <span style='color:red'>emergency department visits</span> by age")
       # caption = "\nSource: CDC | Visualization: Andrew Li")
    #    subtitle = "<span style='color:#66a61e'>Unintentional falls</span>, <br>
    # <span style='color:#e6ab02'>Unintentionally struck by or against an object</span>, <br>
    #   <span style='color:#7570b3'>Motor Vehicle Crashes</span>, <br>
    #    <span style='color:#1b9e77'>Assault</span>, <br>
    #    <span style='color:#e7298a'>Other unintentional injury, mechanism unspeecified</span>, <br>
    #    <span style='color:#d95f02'>Other Intentional self-harm</span>")
ggsave(here::here("tbi", "fig", "tbi_visits.png"), dpi = 320, height = 6, width = 11)


deaths <- tbi_age_tidy %>%
  filter(type == "Deaths") %>%
  ggplot(aes(x = age_group, y = pct, color = injury_mechanism)) +
  geom_point() +
  geom_path(aes(group = injury_mechanism)) +
  geom_hline(yintercept = 0, color = "black", size = 0.3) +
  theme_minimal() +
  theme(legend.position = "none",
        plot.title = element_markdown(),
        plot.subtitle = element_markdown(),
        axis.text = element_text(face = "bold")) +
  scale_y_continuous(breaks = scales::pretty_breaks(n = 5, min.n = 5),
                     labels = scales::label_percent(accuracy = 1)) +
  scale_color_manual(values = names(tbi_colors)) +
  labs(x = "", y = "", color = "",
       title = "<strong> Leading causes of traumatic brain injury<br>related <span style='color:red'>deaths</span> by age")
       # caption = "\nSource: CDC | Visualization: Andrew Li")

ggsave(here::here("tbi", "fig", "tbi_deaths.png"), dpi = 320, height = 6, width = 11)

hospital <- tbi_age_tidy %>%
  filter(type == "Hospitalizations") %>%
  ggplot(aes(x = age_group, y = pct, color = injury_mechanism)) +
  geom_point() +
  geom_path(aes(group = injury_mechanism)) +
  geom_hline(yintercept = 0, color = "black", size = 0.3) +
  theme_minimal() +
  theme(legend.position = "none",
        plot.title = element_markdown(),
        plot.subtitle = element_markdown(),
        axis.text = element_text(face = "bold")) +
  scale_y_continuous(breaks = scales::pretty_breaks(n = 5, min.n = 5),
                     labels = scales::label_percent(accuracy = 1)) +
  scale_color_manual(values = names(tbi_colors)) +
  labs(x = "", y = "", color = "",
       title = "<strong> Leading causes of traumatic brain injury<br>related <span style='color:red'>hospitalizations</span> by age")
       # caption = "\nSource: CDC | Visualization: Andrew Li")
ggsave(here::here("tbi", "fig", "tbi_hospital.png"), dpi = 320, height = 6, width = 11)


tbi_combined <- hospital + visits + deaths
tbi_combined + plot_annotation(
  caption = "Source: CDC | Visualization: Andrew Li"
)
ggsave(here::here("tbi", "fig", "tbi_combined.png"), dpi = 320, height = 6, width = 15)
