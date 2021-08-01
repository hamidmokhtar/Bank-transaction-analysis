#Shiny Server, preprocessing for presonal banking
 

# ------------------------------------------ # 
preprocess_server <- function( input, output, session) {
     
  
  output$newdata <- renderTable({ 
    
    fileTBread = input$InpFile
    if(is.null(fileTBread))     
      return(NULL)   
    
    ThisNewTrans <- read.table(fileTBread$datapath, 
                               sep = ",", 
                               header =F,
                               fill = T)
     if( ncol(ThisNewTrans) < 4 )
       ThisNewTrans$remaining <- NA
     ThisNewTrans$acctype   <- input$AccountType
     ThisNewTrans$accholder <- input$AccountHolder
     names(ThisNewTrans) <- heder
      
     
     ThisNewTrans$date <- as.Date(ThisNewTrans$date, format="%d/%m/%Y")
     ThisNewTrans$month <- format( as.POSIXct(cut(ThisNewTrans$date,
                                                 breaks="month")) ,"%B")
     ThisNewTrans$year <- format( as.POSIXct(cut(ThisNewTrans$date,
                                                breaks="year")) ,"%Y")
     
       
     ThisNewTrans$keyword <- 
         stringr::str_extract(tolower(ThisNewTrans$desc),patt)
     ThisNewTrans <- merge(x=ThisNewTrans,y=catg,
                            by = "keyword",all.x  = T)
     ThisNewTrans <- ThisNewTrans[order(ThisNewTrans$keyword,
                                          ThisNewTrans$date,
                                          decreasing = F,
                                          na.last = FALSE),]
     # }
     ThisNewTrans <<- ThisNewTrans
     head(ThisNewTrans,input$hd) 
     
  })
  
  nText <- observeEvent(input$AcceptTrans, {
  
  AllNewTrans <- rbind(
                   subset(AllNewTrans,select=hederLong),
                   subset(ThisNewTrans,select=hederLong))
  AllNewTrans <<- AllNewTrans[order(AllNewTrans$date,
                                   AllNewTrans$acctype,
                                   AllNewTrans$accholder,
                                   decreasing = T),]

  
  })
  
  dText <- observeEvent(input$MergeAll, {
     
   
    
    
  HistoryTransAll <- read.csv("MasterFile.csv", sep=",",header = T) 
  newAccTrnsAlltemp <- rbind(subset(AllNewTrans,select=hederLong),
                               subset(HistoryTransAll,select = hederLong))
  newAccTrnsAlltemp <- newAccTrnsAlltemp[order(newAccTrnsAlltemp$date,
                                                 newAccTrnsAlltemp$keyword,  
                                                 newAccTrnsAlltemp$acctype,
                                                 newAccTrnsAlltemp$accholder,
                                                 decreasing = T),]
  newAccTrnsAlltemp <- unique(newAccTrnsAlltemp)
    
  write.csv(newAccTrnsAlltemp, 
            "MasterFile_new.csv",
            row.names = F)
  
  })
  output$nText <- renderText({
    ntext()
  })
  
  
}