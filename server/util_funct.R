
validate_data_type <- function(all_trnsx){
  
  all_trnsx[["date"]] <- as.POSIXct(all_trnsx[["date"]])
  all_trnsx[["month.nr"]] <-  month(all_trnsx[["date"]]) 
  all_trnsx[["keyword"]] <- as.factor(all_trnsx[["keyword"]])
  all_trnsx[ is.na(keyword) , keyword := "unknown" ]
  all_trnsx[ is.na(main.cat) , main.cat := "others" ]
  all_trnsx[ is.na(sub.cat) , sub.cat := "unknown" ]
  all_trnsx[["main.cat"]] <- as.factor(all_trnsx[["main.cat"]] )
  all_trnsx[["sub.cat"]] <- as.factor(all_trnsx[["sub.cat"]] )
  setkey(all_trnsx,year,month.nr)
  
  return(all_trnsx)
}
