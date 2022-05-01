library(quantmod)
library(shiny)
library(shinydashboard)
library(dplyr)
library(ggplot2)
library(DT)
library(tidyverse)
library(lubridate)
library(matrixStats)


master_df <- read.csv('df_stocks.csv')
stock_list <- c('XOM', 'AMZN', 'INTC')

master_df$X <- NULL

master_df <- master_df %>% drop_na()
master_df$Date <- strptime(master_df$Date, format='%Y-%m-%d')