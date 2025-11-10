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

#Create Covid-19 World dataframe
world_covid_daily <- covid_df_raw%>%
  filter(location == "World")
view(world_covid_daily)

#Create Covid-19 World Weekly dataframe
world_covid_weekly <- world_covid_daily%>%
  slice(seq(1, n(),by=7))%>%
  select("date","location","new_cases","new_deaths",
         "total_cases","total_deaths",-"location")
view(world_covid_weekly)

#Data inspection
summary(world_covid_weekly)
#Create function to calculate standard deviation
standard_deviation <- function(data, columns) {
  sds <- sapply(data[columns], sd, na.rm = TRUE)
  return(sds)
}
view(standard_deviation(world_covid_weekly))

#Data visualisation of total cases and deaths over time
ggplot(world_covid_weekly,aes(x=date))+
  geom_line(aes(y=total_cases),col="blue")+
  geom_line(aes(y=total_deaths*100),col="red")+
  scale_y_continuous(name="Total Cases", 
                     sec.axis=sec_axis(~./100,name="Total Deaths"))+
  theme(
    axisaxis.title.y.left=element_text(color="blue"),
    axis.text.y.left=element_text(color="blue"),
    axis.title.y.right=element_text(color="red"),
    axis.text.y.right=element_text(color="red")
  )+ 
  ggtitle("Total Covid-19 Cases and Deaths in the World")

#Data visualisation of new cases and new deaths
datavis_world <- function(data, metric, color, title) {
  ggplot(data, aes(y = date, x = .data[[metric]])) +
    geom_line(color = color) +
    labs(x = "Date", y = metric, title = title)
}

world_newcases_plot <- datavis_world(world_covid_weekly,"new_cases","orange",
                                         "New Covid-19 Cases in the World")
world_newcases_plot
world_newdeaths_plot <- datavis_world(world_covid_weekly,"new_deaths","blue",
                                          "New Covid-19 Deaths in the World")
world_newdeaths_plot

#Overlaying both plots
ggplot(world_covid_weekly,aes(x=date))+
  geom_line(aes(y=new_cases),col="blue")+
  geom_line(aes(y=new_deaths*200),col="red")+
  scale_y_continuous(name="New Cases", sec.axis=sec_axis(~./200,name="New Deaths"))+
  theme(
    axisaxis.title.y.left=element_text(color="blue"),
    axis.text.y.left=element_text(color="blue"),
    axis.title.y.right=element_text(color="red"),
    axis.text.y.right=element_text(color="red")
  )+ 
  ggtitle("New Covid-19 Cases and Deaths in the World")