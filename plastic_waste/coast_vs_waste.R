library(tidyverse)
library(ggimage)
library(sf)
library(maptools)
library(scico)
library(patchwork)
theme_set(theme_classic())

coast_vs_waste <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-05-21/coastal-population-vs-mismanaged-plastic.csv")
