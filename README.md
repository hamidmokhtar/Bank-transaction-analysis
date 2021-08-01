# personal_banking

This is a Shinyapp prgram in R which I developed to process my bank trasactions and analyse my expenses and trends. I am sharing here for public to use or improve and share. 

Intruction:
1- open preprocessing.R; then:  
  a- add your new transaction files; double check categories and accept if it is ok, otherwise you can update 'category.csv'; note that new fields may not have \' char.
  b- then click 'Merge the files', the file will be 'MasterFile_new'. if all ok, rename it to 'MasterFile'.
2- Then stop preprocessing.R; and run reporting.R. This report uses 'MasterFile.csv'
