#### Preamble ####
# Purpose: Load aand clean raw data
# Author: Ray Wen
# Data: 28 April 2022
# Contact: ray.wen@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - Download the data from StackOverflow
# - Raw Data available here: https://stackoverflow.com/users/prediction-data?_ga=2.188917099.1567384284.1650887000-373250572.1643712221


#### Workspace setup ####

library(tidyverse)
library(dplyr)
library(hrbrthemes)
library(broom)
library("gridExtra")
library(kableExtra)
library(modelsummary)
library(pROC)

raw <- read.csv("../../inputs/data/survey_results_public.csv")
head(raw)
set.seed(123)

## Creating Data Frame

clean_full <- raw %>% select(c(WorkRemote, ConvertedComp, JobSat, SOVisitFreq, SOPartFreq, WorkLoc, CodeRevHrs, Age, Hobbyist, OrgSize, CareerSat, Gender, Country)) %>% na.omit()

## 75% of the sample size
smp_size <- floor(0.75 * nrow(clean_full))

## set the seed to make your partition reproducible
train_ind <- sample(seq_len(nrow(clean_full)), size = smp_size)

clean <- clean_full[train_ind, ]
test <- clean_full[-train_ind, ]

test <- test %>% mutate(satisfy = case_when(
  JobSat == "Slightly satisfied" ~ "1",
  JobSat == "Slightly dissatisfied" ~ "0",
  JobSat == "Very satisfied" ~ "1",
  JobSat == "Neither satisfied nor dissatisfied" ~ "NA",
  JobSat == "Very dissatisfied" ~ "0",
)) %>% mutate(remote = case_when(
  WorkRemote == "Less than once per month / Never" ~ "0",
  WorkRemote == "A few days each month" ~ "0",
  WorkRemote == "All or almost all the time (I'm full-time remote)" ~ "1",
  WorkRemote == "More than half, but not all, the time" ~ "1",
  WorkRemote == "Less than half the time, but at least one day each week" ~ "0",
  WorkRemote == "About half the time" ~ "0",
  WorkRemote == "It's complicated" ~ "NA",
)) %>% mutate(satisfy = case_when(
  JobSat == "Slightly satisfied" ~ "1",
  JobSat == "Slightly dissatisfied" ~ "0",
  JobSat == "Very satisfied" ~ "1",
  JobSat == "Neither satisfied nor dissatisfied" ~ "NA",
  JobSat == "Very dissatisfied" ~ "0",
))%>% mutate(SOfreq = case_when(
  SOVisitFreq == "I have never visited Stack Overflow (before today)" ~ "0",
  SOVisitFreq == "Less than once per month or monthly" ~ "1",
  SOVisitFreq == "A few times per month or weekly" ~ "2",
  SOVisitFreq == "A few times per week" ~ "3",
  SOVisitFreq == "Daily or almost daily" ~ "4",
  SOVisitFreq == "Multiple times per day" ~ "5",
))%>% mutate(SOPart = case_when(
  SOPartFreq == "I have never participated in Q&A on Stack Overflow" ~ "0",
  SOPartFreq == "Less than once per month or monthly" ~ "1",
  SOPartFreq == "A few times per month or weekly" ~ "2",
  SOPartFreq == "A few times per week" ~ "3",
  SOPartFreq == "Daily or almost daily" ~ "4",
  SOPartFreq == "Multiple times per day" ~ "5",
)) %>% mutate(hobby=case_when(
  Hobbyist == "Yes" ~ "1",
  Hobbyist == "No" ~ "0"
))%>% mutate(careersatisfy = case_when(
  CareerSat == "Slightly satisfied" ~ "1",
  CareerSat == "Slightly dissatisfied" ~ "0",
  CareerSat == "Very satisfied" ~ "1",
  CareerSat == "Neither satisfied nor dissatisfied" ~ "NA",
  CareerSat == "Very dissatisfied" ~ "0",
))%>% mutate(Compsize = case_when(
  OrgSize == "Just me - I am a freelancer, sole proprietor, etc." ~ "0",
  OrgSize == "2-9 employees" ~ "1",
  OrgSize == "10 to 19 employees" ~ "2",
  OrgSize == "20 to 99 employees" ~ "3",
  OrgSize == "100 to 499 employees" ~ "4",
  OrgSize == "500 to 999 employees" ~ "5",
  OrgSize == "1,000 to 4,999 employees" ~ "6",
  OrgSize == "5,000 to 9,999 employees" ~ "7",
  OrgSize == "10,000 or more employees" ~ "8",
)) %>% mutate(loc = case_when(
  WorkLoc == "Office" ~ "0",
  WorkLoc == "Other place, such as a coworking space or cafe" ~ "0",
  WorkLoc == "Home" ~ "1",
)) %>% filter(!remote=="NA") %>% filter(!satisfy=="NA") %>% filter(!SOfreq=="NA") %>% filter(!careersatisfy=="NA")


factorized <- clean %>% mutate(remote = case_when(
  WorkRemote == "Less than once per month / Never" ~ "0",
  WorkRemote == "A few days each month" ~ "0",
  WorkRemote == "All or almost all the time (I'm full-time remote)" ~ "1",
  WorkRemote == "More than half, but not all, the time" ~ "1",
  WorkRemote == "Less than half the time, but at least one day each week" ~ "0",
  WorkRemote == "About half the time" ~ "0",
  WorkRemote == "It's complicated" ~ "NA",
)) %>% mutate(satisfy = case_when(
  JobSat == "Slightly satisfied" ~ "1",
  JobSat == "Slightly dissatisfied" ~ "0",
  JobSat == "Very satisfied" ~ "1",
  JobSat == "Neither satisfied nor dissatisfied" ~ "NA",
  JobSat == "Very dissatisfied" ~ "0",
))%>% mutate(SOfreq = case_when(
  SOVisitFreq == "I have never visited Stack Overflow (before today)" ~ "0",
  SOVisitFreq == "Less than once per month or monthly" ~ "1",
  SOVisitFreq == "A few times per month or weekly" ~ "2",
  SOVisitFreq == "A few times per week" ~ "3",
  SOVisitFreq == "Daily or almost daily" ~ "4",
  SOVisitFreq == "Multiple times per day" ~ "5",
))%>% mutate(SOPart = case_when(
  SOPartFreq == "I have never participated in Q&A on Stack Overflow" ~ "0",
  SOPartFreq == "Less than once per month or monthly" ~ "1",
  SOPartFreq == "A few times per month or weekly" ~ "2",
  SOPartFreq == "A few times per week" ~ "3",
  SOPartFreq == "Daily or almost daily" ~ "4",
  SOPartFreq == "Multiple times per day" ~ "5",
)) %>% mutate(hobby=case_when(
  Hobbyist == "Yes" ~ "1",
  Hobbyist == "No" ~ "0"
))%>% mutate(careersatisfy = case_when(
  CareerSat == "Slightly satisfied" ~ "1",
  CareerSat == "Slightly dissatisfied" ~ "0",
  CareerSat == "Very satisfied" ~ "1",
  CareerSat == "Neither satisfied nor dissatisfied" ~ "NA",
  CareerSat == "Very dissatisfied" ~ "0",
))%>% mutate(Compsize = case_when(
  OrgSize == "Just me - I am a freelancer, sole proprietor, etc." ~ "0",
  OrgSize == "2-9 employees" ~ "1",
  OrgSize == "10 to 19 employees" ~ "2",
  OrgSize == "20 to 99 employees" ~ "3",
  OrgSize == "100 to 499 employees" ~ "4",
  OrgSize == "500 to 999 employees" ~ "5",
  OrgSize == "1,000 to 4,999 employees" ~ "6",
  OrgSize == "5,000 to 9,999 employees" ~ "7",
  OrgSize == "10,000 or more employees" ~ "8",
)) %>% mutate(loc = case_when(
  WorkLoc == "Office" ~ "0",
  WorkLoc == "Other place, such as a coworking space or cafe" ~ "0",
  WorkLoc == "Home" ~ "1",
))

factorized <- factorized %>% filter(!remote=="NA") %>% filter(!satisfy=="NA") %>% filter(!SOfreq=="NA") %>% filter(!careersatisfy=="NA")

# RENAMING COLUMNS FOR PLOTTING

factorized$location_desc <- factorized$WorkLoc
factorized$location_desc[factorized$location_desc == "Other place, such as a coworking space or cafe"] <- "Other"

factorized$sat_desc[factorized$satisfy == "0"] <- "Unsatisfied"
factorized$sat_desc[factorized$satisfy == "1"] <- "Satisfied"

factorized$career_desc[factorized$careersatisfy == "0"] <- "Unsatisfied"
factorized$career_desc[factorized$careersatisfy == "1"] <- "Satisfied"

write_csv(factorized, "outputs/data/factorized_data.csv")
write_csv(raw_data, "outputs/data/test.csv")


         