DECIMALS <- function(DATA, DECIMALS){
  
  temp <- unlist(lapply(ARIMA_RESULTS, is.numeric))
  
  DATA[,temp] <- lapply(DATA[,temp], round, DECIMALS)
  
  return(DATA)
  
}
