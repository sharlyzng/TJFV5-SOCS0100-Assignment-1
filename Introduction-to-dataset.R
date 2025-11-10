if (!require("pacman")){
  install.packages("pacman")
}
library(pacman)
pacman::p_load(
  tidyverse,
  skimr,
  ggplot2,
  gridExtra,
  purrr,
  dplyr,
)

covid_df_raw <- read_csv("covid_full_data.csv")
view(covid_df_raw)

#INSPECTING DATASET
str(covid_df_raw)
skim(covid_df_raw)
summary(covid_df_raw)
names(covid_df_raw)
#The dataset comprises of the following variables:
#date, location, new_cases, new_deaths, total_cases, total_deaths, 
#weekly_cases, weekly_deaths, biweekly_cases, biweekly_deaths

covid_locations <- covid_df_raw|>
  distinct(location)
#Locations grouped by income "High-income countries","Low-income countries",
#"Lower-middle-income countries", "Upper-middle-income countries"

#Locations grouped by continent "Asia","Africa", "European Union (27)", "Europe", "North America", "Oceania",
#"South America","World"