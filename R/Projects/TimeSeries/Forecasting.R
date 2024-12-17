FORECASTING <- function(FILTERED_MODELS, DEVELOPMENT, FORECAST_DATA){
  
  #-------------------------------------------------------------------------------------------------------------------------------#
  # SORT THE MODELS BASED ON FIT AND SUBSET
  #-------------------------------------------------------------------------------------------------------------------------------#
  
  FILTERED_MODELS <- FILTERED_MODELS[order(FILTERED_MODELS$AIC),]
  
  MODEL_FORECAST <- DEVELOPMENT$TARGET
  
  #-------------------------------------------------------------------------------------------------------------------------------#
  # ISOLATE THE MODEL PARAMETERS AND RE-RUN THE ESTIMATION AND FORECAST
  #-------------------------------------------------------------------------------------------------------------------------------#
  
  for(m in 1:nrow(FILTERED_MODELS)){
    
    AR <- FILTERED_MODELS[m,"AR"]
    MA <- FILTERED_MODELS[m,"MA"]
    
    X_VARS <- grepl("^X", colnames(FILTERED_MODELS))
    X_VARS <- sum(is.na(FILTERED_MODELS[m, X_VARS]) == FALSE)
    X_VARS <- paste("X", 1:X_VARS, sep = "")
    X_VARS <- as.character(unlist(FILTERED_MODELS[m, X_VARS]))
    X_VARS <- FORECAST_DATA[, X_VARS]
    
    MIN_DATE <- min(index(DEVELOPMENT))
    MAX_DATE <- max(index(DEVELOPMENT))
    X_VARS <- (X_VARS[index(X_VARS) >= MIN_DATE])
    
    TARGET <- DEVELOPMENT$TARGET
    FC_VAR <- X_VARS[index(X_VARS) > MAX_DATE]
    
    #-------------------------------------------------------------------------------------------------------------------------------#
    # CALCULATE AND STORE THE MODEL FORECASTS 
    #-------------------------------------------------------------------------------------------------------------------------------#
    
    TEMP1 <- arima(TARGET, order = c(AR, 0, MA), xreg = X_VARS[1:length(TARGET),], method = "ML")
    TEMP2 <- matrix(TARGET) + TEMP1$residuals
    TEMP2 <- data.frame(TEMP2)
    TEMP2 <- xts(TEMP2, order.by = index(DEVELOPMENT))
    colnames(TEMP2) <- paste("MODEL ID", FILTERED_MODELS[m,"Index"], sep = " ")
    
    TEMP3 <- predict(TEMP1, newxreg = FC_VAR)
    TEMP3 <- TEMP3$pred
    TEMP3 <- xts(data.frame(TEMP3), index(FC_VAR))
    colnames(TEMP3) <- paste("MODEL ID", FILTERED_MODELS[m,"Index"], sep = " ")
    
    TEMP4 <- rbind(TEMP2, TEMP3)
    
    MODEL_FORECAST <- merge.xts(MODEL_FORECAST,TEMP4)
    
    rm()
    
  }
  
  X <- sum(grepl("^X", colnames(FILTERED_MODELS)))
  
  TEMP <- data.frame(matrix(data = NA, nrow = nrow(FILTERED_MODELS), ncol=2))
  
  for(x in 1:X){
    
    TEMP[,1] <- FILTERED_MODELS[, paste("X", x, sep = "")]
    TEMP[,2] <- FILTERED_MODELS[, paste("EST X", x, sep = "")] * FILTERED_MODELS["Bayesian Probability"]
    TEMP[,3] <- FILTERED_MODELS["Bayesian Probability"]
     
    if(x == 1){
      
      TEMP_X <- TEMP
      
    }
    else{
      TEMP_X <- rbind(TEMP_X, TEMP)
    }
  }
  
  TEMP_X <- aggregate(TEMP_X[,2:3], by=list(Category=TEMP_X$X1), FUN=sum)
  
  AR <- max(FILTERED_MODELS["AR"])
  MA <- max(FILTERED_MODELS["MA"])
  
  TEMP_AR <- data.frame(matrix(data = NA, ncol=3, nrow = AR))
  TEMP_MA <- data.frame(matrix(data = NA, ncol=3, nrow = MA))
  TEMP_INT <- data.frame(matrix(data = NA, ncol=3, nrow = 1))
  
  if(AR > 0){
    
    for(i in 1:AR){
      
      TEMP_AR[i,1] <- paste("AR", i, sep="")
      TEMP_AR[i,2] <- sum(FILTERED_MODELS[paste("EST AR ", i, sep = "")] * FILTERED_MODELS["Bayesian Probability"], na.rm=TRUE)
      TEMP_AR[i,3] <- sum(FILTERED_MODELS[FILTERED_MODELS$AR == i,"Bayesian Probability"])
      
    }
    
  }
  
  if(MA > 0){
    
    for(i in 1:MA){
      
      TEMP_MA[i,1] <- paste("MA", i, sep="")
      TEMP_MA[i,2] <- sum(FILTERED_MODELS[paste("EST MA ", i, sep = "")] * FILTERED_MODELS["Bayesian Probability"], na.rm=TRUE)
      TEMP_MA[i,3] <- sum(FILTERED_MODELS[FILTERED_MODELS$MA == i,"Bayesian Probability"])
      
    }
    
  }
  
  TEMP_INT[1,1] <- "Intercept"
  TEMP_INT[1,2] <- sum(FILTERED_MODELS["EST Intercept"] * FILTERED_MODELS["Bayesian Probability"], na.rm=TRUE)
  TEMP_INT[1,3] <- sum(FILTERED_MODELS[is.na(FILTERED_MODELS["EST Intercept"]) == FALSE, "Bayesian Probability"])
  
  
 colnames(TEMP_INT) <- c("Variable", "Coefficient", "Probability")
 colnames(TEMP_AR) <- c("Variable", "Coefficient", "Probability")
 colnames(TEMP_MA) <- c("Variable", "Coefficient", "Probability")
 colnames(TEMP_X) <- c("Variable", "Coefficient", "Probability")
 
 BAYESIAN_MODEL <- rbind(TEMP_INT,TEMP_AR,TEMP_MA, TEMP_X)
  
 BAYESIAN_FORECAST <- data.frame(as.matrix(MODEL_FORECAST[,2:ncol(MODEL_FORECAST)]) %*% as.matrix(FILTERED_MODELS$`Bayesian Probability`))
  
 colnames(BAYESIAN_FORECAST) <- c("Bayesian Model")
  
 FORECAST <- list()
 
 FORECAST$MODEL_FORECAST <- MODEL_FORECAST
 FORECAST$BAYESIAN_MODEL <- BAYESIAN_MODEL
 FORECAST$BAYESIAN_FORECAST <- BAYESIAN_FORECAST
 
 return(FORECAST)
 
   
}
