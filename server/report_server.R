


# ------------------------------------------ # 
report_server <- function(input, output) {
 
  
  output$overview_income_expnses <- renderTable({ 
    income <- all_trnsx[ main.cat %in% income_cats | sub.cat %in% income_cats , .(income = sum(amount)), by = .(year,month.nr) ]
    expenditure <- expenses[ , .(expenditure = sum(amount)), by = .(year,month.nr) ]
    all_summary <- income[  expenditure ]
    tail(all_summary, input$length_summ)
  })
  
  ################ Tab 1:  Transactions #############
  output$expenseTable <- renderTable({
    if(input$reportType == "Summary" ){ 
      expenses_short[month.nr == input$UserMonth1 & year == input$UserYear1, .(main.cat, amount) ]
     } else{
      expenses_summary[month.nr == input$UserMonth1 & year==input$UserYear1, .(main.cat,sub.cat,keyword,amount)]
     }
  })
  
  output$keywordTable <- renderTable({
         expenses[ month.nr == input$UserMonthKeyw & year == input$UserYearKeyw & keyword == input$Keyw
                  , .(amount,date,keyword,main.cat,sub.cat)] 
  })
  
  ############# Tab 2: Category Comparison  ###########################
  output$PlotCategComp <- renderPlot({
     
    bar <- ggplot(expenses_short[month.nr ==input$UserMonth2 & year == input$UserYear2 ]
                  , aes(main.cat,-amount))
    bar + geom_bar(stat = "identity", width = 0.5,col ="Blue",fill = "#FF6666") +
      theme( axis.text.x = element_text(angle=65, vjust=0.6) ) +
      geom_text(aes(label = amount), vjust=-0.6, color="black",
                position = position_dodge(1.9), size=3.5)   + 
                labs(title="Expenses this month")  +
                theme(text = element_text(size=22))
  })
  
  
  
  ############# Tab 3: Month to year Comparison  ###########################
  output$CategMeanMeanPlot <- renderPlot({

      UserMonth_3 <- as.integer(input$UserMonth3)
      UserYear_3 <- as.integer(input$UserYear3)
         
      histYear = as.integer(UserYear_3 - ceiling((input$length3 - UserMonth_3-1)/12) )
      validMnt = 12 -  ((input$length3 - UserMonth_3-1) %% 12)
      #if(input$length3 == UserMonth_3) validMnt = 0
      
      RecentHistData <- expenses[(year > histYear & year < UserYear_3) |
                                  (year == UserYear_3 & month.nr < UserMonth_3) |
                                  (year == histYear &  month.nr >=  validMnt) 
                                  , .(amount = sum(amount)/input$length3) 
                                  , main.cat ][ , period :=  "History"]
        
       
      ExpensesCateg_monthly <- expenses[(year == UserYear_3 & month.nr < UserMonth_3) | year < UserYear_3 
                                        , .(amount = mean(amount) ) 
                                        , .(main.cat,month.nr,year) ]
    
      ExpensesCateg_LastMonth <- expenses[ (month.nr == UserMonth_3 -1 & UserMonth_3 != 1 & year == UserYear_3) |  
                                            ( month.nr == 12 & UserMonth_3 == 1 & year == UserYear_3-1 )  
                                            , .(amount = sum(amount)) 
                                            , main.cat ][ ,period := "Month before" ]
       
      ExpensesCateg_ThisMonth <- expenses[year ==  UserYear_3 & month.nr ==  UserMonth_3 
                                          , .(amount =sum(amount)) 
                                          , .(main.cat) ][ ,  period := "Selected month"]
                                                                                   
       
      
      sscol<-c("main.cat", "amount","period")
      meanCompares <-   rbind( subset(RecentHistData,select=sscol),
                              subset(ExpensesCateg_ThisMonth,select=sscol), 
                                subset(ExpensesCateg_LastMonth,select=sscol)
                                )[, amount := round(amount,0) ]
      
      meanBarplot <- ggplot(meanCompares, 
                            aes(fill=period , y=-amount, x=main.cat ,label=amount)) + 
                            geom_bar(position="dodge", stat="identity") +
                            theme(text = element_text(size=22)) + 
                            geom_text(aes(label = amount), vjust=-0.6, color="black",
                                   position = position_dodge(1.0),
                                   size=3.5)   
       
      print(meanBarplot)
  
  })

  # output$HistoryTable <- renderTable({
  #   
  #   UserMonth_3 <- as.integer(input$UserMonth3)
  #   UserYear_3 <- as.integer(input$UserYear3)
  #   
  #   histYear = as.integer(UserYear_3 - ceiling((input$length3 - UserMonth_3-1)/12) )
  #   validMnt = 12 -  ((input$length3 - UserMonth_3-1) %% 12)
  #   #if(input$length3 == UserMonth_3) validMnt = 0
  #   
  #   RecentHistData <- Expenses[(Expenses$year > histYear & Expenses$year < UserYear_3) |
  #                                (Expenses$year == UserYear_3 & Expenses$month.nr < UserMonth_3) |
  #                                (Expenses$year == histYear &  Expenses$month.nr >=  validMnt)
  #                              , ]
  #   
  #   RecentHistData <- RecentHistData[RecentHistData$main.cat=="others",]  
  #   
  #   RecentHistData
  #   
  # })
   
  ############# Tab 4: subcategory  ###########################
  output$SubcategoryPlot <- renderPlot({
        
        thisYear =  expenses[,max(year)] 
        thisMonthNr = expenses[ year==thisYear, max(month.nr)] 
        
        histYear = as.integer(thisYear - ceiling((input$length4 - thisMonthNr)/12) )
        validMnt = 12L -  ((input$length4 - thisMonthNr) %% 12L)
        if(input$length4%%12L == thisMonthNr) validMnt = 0
        
        TrendData <- expenses[ main.cat == as.character(input$UserCategory4) & (year > histYear |
                                    (year  == histYear & month.nr >=  validMnt) ) ]
        TrendData[ , Sdate := ifelse (month.nr >9 , as.character(month.nr ), paste0("0",month.nr) ) ]
        TrendData[ , Sdate := paste0(as.character(year),"-",Sdate) ][order(Sdate)]
        
        yrCats <- TrendData[ , .(amount = sum(amount)), .( Sdate , sub.cat )] 
        
        thePlot <- ggplot(yrCats, 
                            aes(x= Sdate, y= -amount, fill= sub.cat))  + 
                            geom_bar( position= "dodge", stat= "identity") +
                            theme(text= element_text(size= 22),
                            axis.text.x= element_text(angle= 90, hjust= 1)) 
          
        print(thePlot) 
  })
  
  
  output$subcategoryTable <- renderTable({

      thisYear = expenses[,max(year)] 
      thisMonthNr = expenses[ year==thisYear, max(month.nr)] 
  
      histYear = as.integer(thisYear - ceiling((input$length4 - thisMonthNr)/12) )
      validMnt = 12 -  ((input$length4 - thisMonthNr) %% 12)
      if(input$length4 == thisMonthNr) validMnt = 0
  
      TrendData <- expenses[ main.cat == as.character(input$UserCategory4) & ( year > histYear | (year  == histYear & month.nr >=  validMnt)) ]  
      
      TrendData[ , Sdate :=  ifelse (month.nr >9 ,  as.character(month.nr ), paste0("0",TrendData$month.nr) ) ]
      TrendData[ , Sdate := paste0(as.character(year),"-",Sdate) ][order(Sdate)]
      
      yrCats <- TrendData[ , .(amount = sum(amount)), .(  Sdate , sub.cat )] 
        
         
      if(input$reportType4 == "Transations" )
         pres_tabel<-yrCats[order(Sdate)] 
      else 
         pres_tabel <- yrCats[ , .(mean = sum(amount)/  input$length4) ,  sub.cat]
            
          
         pres_tabel
  })
  }
 
 
