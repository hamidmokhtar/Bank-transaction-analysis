#Shiny Server, report for presonal banking
#global parameters 

library(shiny)
library(data.table)
library(ggplot2)
library(lubridate) 
#library(RColorBrewer)
# jBrewColors <- brewer.pal(n = 8, name = "Dark2")



income_cats <- c("salary")
not_expense_cats <- c("paid back","inACC")

setwd("D:/pb_git/")
source('server/util_funct.R')

all_trnsx <- setDT(read.csv("MasterFile.csv",header = T))
all_trnsx <- validate_data_type(all_trnsx)

expenses <- all_trnsx[ !main.cat %in% not_expense_cats]
expenses_summary <- expenses[ , .( amount = sum(amount) )
                              , by =.(keyword,main.cat,  sub.cat ,month, month.nr, year)  ][order(main.cat)]
expenses_short <- expenses_summary[, .(amount = sum(amount)) 
                                   , by = .(main.cat, month, month.nr, year) ]
minYear = expenses[,min(year)]
maxYear = expenses[,max(year)]


source("server/report_server.R")
source("ui/report_ui.R")
shinyApp( ui = report_ui, server = report_server  ) 




