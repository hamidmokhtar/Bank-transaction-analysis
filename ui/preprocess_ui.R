#UI for pre-processing for personal banking



preprocessing_ui <- fluidPage(
  
  titlePanel("Pre-processing input files."),
  
  sidebarLayout(
    sidebarPanel(
      
      tags$hr(),
      # fileInput("CategFile", "Choose Category csv File",
      #           multiple = FALSE,
      #           accept = c("text/csv",
      #                      "text/comma-separated-values,text/plain",
      #                      ".csv")),
      # actionButton("syncCateg","Update Category.csv"),
      # p("Click the button to update the category.csv for pre-processing."),
      # 
      # # textOutput( "CategoryMsg" ),
      # tags$hr(),
      
      radioButtons("AccountType", "Account Type",
                   choices = c(Credit = 'Credit1',
                               CreditCard = 'CreditCard',
                               Savings = 'Savings',
                               Netbank = 'Netbank'),
                   selected = 'CreditCard'),
      
      radioButtons("AccountHolder", "Account Holder",
                   choices = c(Joint = 'Joint',
                               Alex = 'Alex',
                               Jenny = 'Jenny'),
                   selected = 'Joint'), 
      tags$hr(),
      
      
      # Input: Select a file ----
      fileInput("InpFile", "Choose CSV File",
                multiple = FALSE,
                accept = c("text/csv",
                           "text/comma-separated-values,text/plain",
                           ".csv")),
      numericInput("hd","display size",5),
      tags$hr(),
  
  p("Click the button to accept the pre-processed input file. 
    Then either choose a new input file or finalise the preprocessing. "),
  p("Accept only when no more category allocation is required."),
  
  actionButton("AcceptTrans","Accept the file"),
  
  br(),
  tags$hr(),
  p("Click the button to merge all accepted files to MasterFile.csv.  
    You can then manually change some categorisation in spreadsheet editor."),
  
  actionButton("MergeAll","Finalise and save all"),
  p("Check categories in MasterFile.csv")
  ),
  
  
  mainPanel( 
    tags$hr(),
  tableOutput(outputId = "newdata"),
  tableOutput(outputId = "newdatacateg")
  )
)
   
  
)