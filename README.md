# Personal bank transaction analysis

This is a small Shinyapp program in R which I developed to process my bank transactions and analyse my expenses and trends. I am sharing here publicly to interested users/developers to improve and share. 

In first step, upload new transaction files in the app and check the categories and keywords of new transactions. Based on the description of transaction records, each row is labelled with a keyword. If new keywords needed to be added, you can add the keywords in the categories.csv file and upload your transactions again. Once you're happy with the keywords and allocated categories, click Merge to merge the new files with existing combined transaction file from previous analysis. This merged file is then loaded by Reporting.R to show you analysis graphs.  


Instruction:

1- open preprocessing.R; then: 

  a- add your new transaction files (one-by-one); double check categories and accept if it is ok, otherwise you can update 'category.csv'; (note that new fields may not have \' char. in categories.csv)
  
  b- then click 'Merge the files', the file will be 'MasterFile_new'. if all ok, rename it to 'MasterFile'.
  
2- Then stop preprocessing.R; and run reporting.R. This report uses 'MasterFile.csv'. There are 5 major report types in this app. 

I hope it is interesting for someone.
