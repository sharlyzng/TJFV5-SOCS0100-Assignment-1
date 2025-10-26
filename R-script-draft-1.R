#Packages required
if (!require("pacman")){
  install.packages("pacman")
}
pacman::p_load(
  tidyverse,
  skimr,
  glue,
  ggplot2,
  gridExtra
)
#Inspecting dataset
covid_df_raw <- read_csv("covid_full_data.csv")
view(covid_df_raw)
str(covid_df_raw)
glimpse(covid_df_raw)
#Tidying dataset

#Finding out distinct countries
covid_countries <- covid_df_raw|>
  distinct(location)
#Pivot wider
covid_countries_totaldeaths <- covid_df_raw%>%
  select(date,location,total_deaths)%>%
  pivot_wider(
    names_from = location,
    values_from = total_deaths
  )
view(covid_countries_totaldeaths)
covid_countries_totalcases <- covid_df_raw%>%
  select(date,location,total_cases)%>%
  pivot_wider(
    names_from = location,
    values_from = total_cases
  )
view(covid_countries_totalcases)
