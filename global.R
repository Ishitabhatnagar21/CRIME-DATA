#installing packages and then loading all the required libraries 
library(dplyr)
library(ggplot2)
library(ggtext)
library(plotly)
library(readr)

library(readr)
dataset1 <- read_csv("report.csv")
#cleaning data of all the null values , so we could have better and accurate visualizations
dataset1 <- na.omit(dataset1)
dataset1 %>% str()

# In ui , we have to make certain choices , which crime we want to look out for or want to create histogram bboxplot for. 
# we use c1, c2,c3 as choices
# it uses pipeline operator and select query to select the columns, we want to have a choice from and potray their names

c1 = dataset1 %>% select(crimes_percapita, rapes_percapita, homicides_percapita, assaults_percapita) %>% names()
c3= dataset1 %>% select(crimes_percapita, rapes_percapita, homicides_percapita, assaults_percapita) %>% names()
c2= dataset1 %>% select(agency_jurisdiction, agency_code) %>% names() 




