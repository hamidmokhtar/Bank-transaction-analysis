
report_ui <- fluidPage(
  
  titlePanel("Personal banking report using MasterFile.csv"),
  tabsetPanel( 
    
    tabPanel("Instruction:",
             h3("1- open preprocessing.R; then: "),
             h3("---a- add your new transaction files; double check categories and accept if it is ok, otherwise "),
             h3("----- you can update 'category.csv'; note that new fields may not have \' char."),
             h3("---b- then click 'Merge the files', the file will be 'MasterFile_new'. if all ok, rename it to 'MasterFile'. "),
             h3("2- Then stop preprocessing.R; and run this reporting.R. This report uses 'MasterFile.csv'"),
             h3("-------------------------------------------")  
             
    ),
    tabPanel("Subtotals",
             h3("Overall transactions"),
             
             sidebarLayout(
               sidebarPanel( 
                 sliderInput("length_summ", "History length", min= 3, max= 12, value=3)  ),
               tags$hr()
             ),
             mainPanel({
               tableOutput('overview_income_expnses')
             })
             
    ),
    tabPanel("Transactions by Categories",
             h3("Monthly transactions"),
             
             sidebarLayout(
               sidebarPanel(
                 radioButtons("reportType", "Detailed/summary",
                              choices = c(Summary = 'Summary',
                                          Detailed = 'Detailed'),
                              selected = 'Detailed'), 
                 tags$hr(),
                 sliderInput("UserMonth1", "Month", min= 1, max=12, value= 1), 
                 sliderInput("UserYear1", "Year", min= minYear, max= maxYear, value=maxYear, step= 1) 
               ),
               mainPanel({
                 tableOutput('expenseTable')
               })
             )
    ),
    tabPanel("Category Comparison",
             h3("Comparing the monthly expenses by categories"),
             fluidPage(
               title = "Comparing the monthly expenses by categories",
               plotOutput("PlotCategComp"),
               hr(),
               fluidRow(
                 column(3,
                        h4("Expenses of a month by category"),
                        sliderInput("UserMonth2", "Month", min= 1, max= 12, value= 1)
                          
                 ),
                 column(4, h4("_"), 
                        offset = 1, 
                        sliderInput("UserYear2", "Year", min= minYear, max= maxYear, value= maxYear, step= 1)
                        
                 )
               )
             )
    ),
    tabPanel("Month & Year-Mean",
             fluidPage(
               title = "Compare with the average",
               plotOutput("CategMeanMeanPlot"), 
               hr(),
               fluidRow(
                 h4("Comparing the expenses of the selected month, its previous month, and the history average with selected range (inclusive of the selected month)"),
                 column(3, 
                        sliderInput("UserMonth3", "Month", min= 1, max= 12, value= 1)
                        
                 ),
                 column(4, h4(""), 
                        offset = 1, 
                        sliderInput("UserYear3", "Year", min= minYear, max= maxYear, value= maxYear, step= 1)
                      
                 ),
                 column(5,h4("history length"),
                        offset = 1,
                        sliderInput("length3", "History length", min= 3, max= 36, value= 12)  )
               )
             )
    ),
    tabPanel("Category details",
             h3("Yearly category trend by sub-categories"),
             sidebarLayout(
               sidebarPanel(  
                 selectInput("UserCategory4","Category",
                             choices = sort(unique(expenses_summary[["main.cat"]])),
                             selected = "bill"),
                 sliderInput("length4", "History length", min= 1, max= 24, value= 12),
                 radioButtons("reportType4", "Detailed/summary",
                              choices = c(Month_subtotal = 'Transations',
                                          Mean = 'Mean'),
                              selected = 'Transations')
               ),
               mainPanel({ 
                 mainPanel(
                   plotOutput("SubcategoryPlot")  ,
                   tableOutput("subcategoryTable")
                 )
               })
             )
    ),
    
    tabPanel("Keyword search",
             h3("Monthly keyword transactions"),
             
             sidebarLayout(
               sidebarPanel( 
                 sliderInput("UserMonthKeyw", "Month", min=1, max= 12, value=1),
                
                 sliderInput("UserYearKeyw", "Year", min= minYear, max= maxYear, value= maxYear, step= 1),
  
                 selectInput("Keyw","Keyword",
                             choices = sort(unique(expenses_summary[["keyword"]])),
                             selected = expenses_summary[1,keyword] )
               ),
               mainPanel({
                 tableOutput('keywordTable')
               })
             )
    )
    
  ))

