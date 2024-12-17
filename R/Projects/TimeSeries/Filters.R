FILTERS <- function(RESULTS, EST_P, WHITE_NOISE_P){
  
  X_VARS <- grepl("^X", colnames(ARIMA_RESULTS))
  
  SUMMARY <- data.frame(matrix(data=NA, nrow = nrow(RESULTS), ncol = 7))
  colnames(SUMMARY) <- c("Exogonous Estimates Significance", "AR Estimates Significance", "MA Estimates Significance", "Residuals White Noise", "Residual Normality Test", "Exogenous Sign Violation", "Excluded" )
  
  
  for(m in 1:nrow(RESULTS)){
    
    #-------------------------------------------------------------------------------------------------------------------------------#
    # TEST SIGNIFICANCE OF THE ESTIMATES
    #-------------------------------------------------------------------------------------------------------------------------------#
    X <- sum(is.na(RESULTS[m, X_VARS]) == FALSE)
    AR <- RESULTS[m, "AR"]
    MA <- RESULTS[m, "MA"]
    
    TEST_X <- 0
    TEST_AR <- 0
    TEST_MA <- 0
    TEST_LB <- 0
    TEST_SIGN <- 0
    TEST_SW <- 0
    
    for(x in 1:X){
      
      NAME <- paste("P-VAL X", x, sep = "")
      
      VAR <- as.character(RESULTS[m, paste("X", x, sep = "")])
      VAR <- substr(VAR, 1, length(VAR) - 5)
      
      EXP_SIGN <- VARIABLE_SIGNS[index(VAR), 2]
      ACT_SIGN <- paste("EST X", x, sep = "")
      ACT_SIGN <- sign(RESULTS[m, ACT_SIGN])
      
      if(EXP_SIGN != 0){if(EXP_SIGN != ACT_SIGN){ TEST_SIGN <- 1}}
      
      if(is.na(RESULTS[m, NAME]) == TRUE){ TEST_X <- 1 } 
      else{if(RESULTS[m, NAME] > EST_P){ TEST_X <- 1 }}
      
    }
    
    if(AR > 0){
      for(x in 1:AR){
        NAME <- paste("P-VAL AR ", x, sep = "")
        if(is.na(RESULTS[m, NAME]) == TRUE){ TEST_AR <- 1 } 
        else{if(RESULTS[m, NAME] > EST_P){ TEST_AR <- 1 }}
      }
    }
    
    if(MA > 0){for(x in 1:MA){
      NAME <- paste("P-VAL MA ", x, sep = "")
      if(is.na(RESULTS[m, NAME]) == TRUE){ TEST_MA <- 1 } 
      else{if(RESULTS[m, NAME] > EST_P){ TEST_MA <- 1 }}
    }
    }
    
    if(is.na(RESULTS[m, "Ljung-Box P-Value"])== TRUE){ TEST_LB <- 1}
    else{if(RESULTS[m, "Ljung-Box P-Value"] < WHITE_NOISE_P){ TEST_LB <- 1 }}
    
    if(is.na(RESULTS[m, "Shapiro-Wilk P-Value"])== TRUE){ TEST_SW <- 1}
    #else{if(RESULTS[m, "Shapiro-Wilk P-Value"] < WHITE_NOISE_P){ TEST_SW <- 1 }} 
    
    TEST <- max(TEST_X, TEST_AR, TEST_MA, TEST_LB, TEST_SW, TEST_SIGN)
    
    SUMMARY[m, 1] <- TEST_X
    SUMMARY[m, 2] <- TEST_AR
    SUMMARY[m, 3] <- TEST_MA
    SUMMARY[m, 4] <- TEST_LB
    SUMMARY[m, 5] <- TEST_SW
    SUMMARY[m, 6] <- TEST_SIGN
    SUMMARY[m, 7] <- TEST 
    
  }
  
  KEEP <- as.logical(SUMMARY$Excluded) == FALSE
  
  TEMP <- RESULTS[KEEP, ]
  
  #-------------------------------------------------------------------------------------------------------------------------------#
  # BAYESIAN MODEL AVERAGING
  #-------------------------------------------------------------------------------------------------------------------------------#
  
  TEMP["k"] <- rowSums(is.na(TEMP[, grepl("^X", colnames(TEMP))]) == FALSE) + TEMP["AR"] + TEMP["MA"] + 1
  PP <- 1/nrow(TEMP) 
  T <- nrow(DEVELOPMENT)
  TEMP["Bayesian Weight"] <- (PP)*(T^(-TEMP["k"]/2))*(TEMP["SSE"]^(-T/2))
  TEMP["Bayesian Probability"] <- TEMP["Bayesian Weight"]/sum(TEMP["Bayesian Weight"])
  
  OUT <- list()
  
  OUT$OUTPUT <- TEMP
  OUT$SUMMARY <- SUMMARY
  
  return(OUT)
  
}
