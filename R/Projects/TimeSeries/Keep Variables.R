KEEP <- function(DATA, VARIABLES){
  
  TEMP <- grepl("X X X X", colnames(DATA))
  
  for(v in 1:length(VARIABLES)){
    
    VAR <- as.character(VARIABLES[v])
    
    TEMP <- TEMP + grepl(VAR, colnames(DATA))
    
  }
  
  TEMP <- as.logical(TEMP)
  
  OUTPUT <- DATA[, TEMP]
  
  return(OUTPUT)
  
}
