if (!require("pacman")){
  install.packages("pacman")
}
library(pacman)
pacman::p_load(
  tidyverse,
  skimr,
  glue,
  ggplot2,
  gridExtra,
  purrr,
  dplyr,
)

covid_df_raw <- read_csv("covid_full_data.csv")

#Creating new dataframe
covid_by_income <- covid_df_raw%>%
  rename(income_group = location)%>%
  filter(grepl("countries",income_group))
view(covid_by_income)

#Notice that data by income is only updated weekly
covid_by_income_weekly <- covid_by_income%>%
  filter("new_cases" != 0)
view(covid_by_income_weekly)

#New column for survival rate
covid_by_income_weekly <- covid_by_income_weekly%>%
  mutate(survival_rate = (total_cases-total_deaths)/total_cases)%>%
  select(date,income_group,survival_rate)
view(covid_by_income_weekly)
covid_income_survivalrate$date <- as.Date(covid_income_survivalrate$date)

#Converting NaN to NA
covid_income_survivalrate <- covid_income_survivalrate%>%
  mutate_all(~ifelse(is.nan(.), NA, .))
covid_income_survivalrate$date <- as.Date(covid_income_survivalrate$date)

#Filtering for wanted rows
covid_income_survivalrate$date <- as.Date(covid_income_survivalrate$date)
filtered_covid_income_survivalrate <- covid_income_survivalrate%>%
  dplyr::filter(survival_rate>0.85 & date>"2020-06-01")
view(filtered_covid_income_survivalrate)

covid_income_survival_plot <- ggplot(filtered_covid_income_survivalrate,
                                     aes(x=date,y=survival_rate,
                                         colour=income_group))+
  geom_line()+
  scale_color_manual(
    name = "Income Group",
    values = c("High-income countries" = "blue",
               "Low-income countries" = "red",
               "Lower-middle-income countries" = "brown",
               "Upper-middle-income countries" = "orange")
  ) +
  labs(title = "Covid-19 Survival Rate by Income",
       y = "Survival Rate",
       x = "Date")
covid_income_survival_plot
