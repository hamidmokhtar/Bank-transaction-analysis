

library(shiny)

setwd("D:/pb_git/")


ThisNewTrans<- data.frame(matrix(ncol = 6, nrow = 0))
AllNewTrans <- data.frame(matrix(ncol = 11, nrow = 0))
heder <- c("date","amount","desc","remaining","acctype","accholder")
hederLong <- c("date","amount","desc","remaining","acctype","accholder",
               "month","year","keyword","main.cat","sub.cat")
colnames(AllNewTrans) <- hederLong


fileTBused =  "categories.csv"
catg<- read.table(fileTBused,sep = ",",header =T)
catg$keyword <- tolower(catg$keyword)
keyUniq <- unique(catg$keyword)

patt <- paste(catg$keyword,collapse = "|")




source("server/preprocess_server.R")
source("ui/preprocess_ui.R")
shinyApp( ui = preprocessing_ui, server = preprocess_server  ) 

