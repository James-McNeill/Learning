TRANSFORMATIONS <- function(DATA, LOGIT, DIFF, ROC){
  
  RAW_DATA <- DATA
  colnames(RAW_DATA) <- paste(colnames(RAW_DATA), "_R", sep = "")
  
  if(LOGIT == "Y"){
    
    LOGIT_DATA <- log(DATA/(1-DATA))
    colnames(LOGIT_DATA) <- paste(colnames(LOGIT_DATA), "_L", sep = "")
    
  }
  
  if(DIFF == "Y"){
    
    DIFF_DATA <- diff(DATA)
    colnames(DIFF_DATA) <- paste(colnames(DIFF_DATA), "_D", sep = "")
    
  }
  
  if(ROC == "Y"){
    
    ROC_DATA <- diff(DATA)/ lag.xts(DATA)
    colnames(ROC_DATA) <- paste(colnames(ROC_DATA), "_Y", sep = "")
    
  }
  
  if(exists("RAW_DATA") == TRUE){
    
    OUTPUT <- RAW_DATA
    
    if(exists("LOGIT_DATA") == TRUE){
      OUTPUT <- merge.xts(OUTPUT, LOGIT_DATA, all=FALSE, join = "left")
    }
    
    if(exists("DIFF_DATA") == TRUE){
      OUTPUT <- merge.xts(OUTPUT, DIFF_DATA, all=FALSE, join = "left")
    }
    
    if(exists("ROC_DATA") == TRUE){
      OUTPUT <- merge.xts(OUTPUT, ROC_DATA, all=FALSE, join = "left")
    }
  }
  
  return(OUTPUT)
  
}


LAGS <- function(DATA, LAGS){
  
  for(l in 0:LAGS){
    
    if(l == 0){
      
      OUTPUT <- DATA
      colnames(OUTPUT) <- paste(colnames(DATA), "_L0", sep="")
      
    }
    else{
      
      LAG_DATA <- lag.xts(DATA, k=l)
      colnames(LAG_DATA) <- paste(colnames(DATA), "_L", l, sep = "")
      
      OUTPUT <- merge.xts(OUTPUT, LAG_DATA, all = FALSE, join = "left")
      
      
    }
    
  }
  
  return(OUTPUT)
}


