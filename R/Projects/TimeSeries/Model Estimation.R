ARIMA_MODEL_ESTIMATION <- function(MODELS, TARGET){
  
  ARIMA_RESULTS <- data.frame(matrix(data=NA, nrow=nrow(MODELS), ncol = ncol(MODELS)))
  ARIMA_RESULTS[, 1:ncol(MODELS)] <- MODELS
  colnames(ARIMA_RESULTS) <- colnames(MODELS)
  
  
  for (m in 1:nrow(MODELS)){
    
    # ISOLATE THE EXOGENOUS VARIABLES FROM THE DEVELOPMENT DATA
    x_vars <- MODELS[m,1:comb]
    x_vars <- as.character(unlist(x_vars))
    NA_Check <- as.numeric(is.na(x_vars) == FALSE)
    x_count <- sum(NA_Check)
    x_vars <- x_vars[NA_Check > 0]
    x_vars <- DEVELOPMENT[,x_vars]
    
    #-------------------------------------------------------------------------------------------------------------------------------#
    # STORE THE ORDER OF THE MODEL TO BE TESTED
    #-------------------------------------------------------------------------------------------------------------------------------#
    
    AR <- MODELS[m, comb+1]
    MA <- MODELS[m, comb+2]
    
    #-------------------------------------------------------------------------------------------------------------------------------#
    # SETUP EMPTY TABLES TO STORE MODEL ESTIMATION RESULTS AND PARAMETERS
    #-------------------------------------------------------------------------------------------------------------------------------#
    
    if(m == 1){
      
      COEFFICIENTS <- data.frame(matrix(data = NA, nrow= nrow(MODELS), ncol = comb + p + q + 1 ))
      
      if(p > 0 & q > 0){colnames(COEFFICIENTS) <- c(colnames(COEFFICIENTS[,1:comb]), paste("AR", 1:p), paste("MA", 1:q), "Intercept")}
      if(p > 0 & q == 0){colnames(COEFFICIENTS) <- c(colnames(COEFFICIENTS[,1:comb]), paste("AR", 1:p), "Intercept")}
      if(p == 0 & q > 0){colnames(COEFFICIENTS) <- c(colnames(COEFFICIENTS[,1:comb]), paste("MA", 1:q), "Intercept")}
      if(p == 0 & q == 0){colnames(COEFFICIENTS) <- c(colnames(COEFFICIENTS[,1:comb]), "Intercept")}
      
      STANDARD_ERRORS <- COEFFICIENTS
      P_VALUES <- COEFFICIENTS
      
      RESIDUALS <- data.frame((matrix(data=NA, nrow = nrow(MODELS), ncol= 5)))
      
      colnames(RESIDUALS) <- c("AIC","SSE", "MSE", "Ljung-Box P-Value", "Shapiro-Wilk P-Value")
      
    }
    
    #-------------------------------------------------------------------------------------------------------------------------------#
    # ESTIMATION OF THE ARIMA MODEL
    #-------------------------------------------------------------------------------------------------------------------------------#
    
    ARIMA <- arima(TARGET, order= c(AR, 0, MA), xreg= x_vars, method = "ML")
    
    #-------------------------------------------------------------------------------------------------------------------------------#
    #STORE THE COEFFICIENTS AND STANDARD ERRORS OF THE MODEL ESTIMATION
    #-------------------------------------------------------------------------------------------------------------------------------#
    
    ARIMA_SE <- data.frame(sqrt(diag(ARIMA$var.coef)))
    
    TEMP_P <- data.frame(1 - pnorm(abs(ARIMA$coef / sqrt(diag(ARIMA$var.coef)))))
    TEMP_R <- ARIMA$residuals^2
    
    if(AR > 0){
      
      COEFFICIENTS[m, (comb+1):(comb+AR)] <- ARIMA$coef[1:AR]
      STANDARD_ERRORS[m, (comb+1):(comb+AR)] <- ARIMA_SE[c(1:AR),1]
      P_VALUES[m, (comb+1):(comb+AR)] <- TEMP_P[c(1:AR), 1]
      
    }
    if(MA > 0){
      
      COEFFICIENTS[m, (comb+AR+1):(comb+AR+MA)] <- ARIMA$coef[(AR+1):(AR+MA)]    
      STANDARD_ERRORS[m, (comb+AR+1):(comb+AR+MA)] <- ARIMA_SE[c((AR+1):(AR+MA)),1]    
      P_VALUES[m, (comb+AR+1):(comb+AR+MA)] <- TEMP_P[c((AR+1):(AR+MA)),1]    
      
    }
    
    COEFFICIENTS[m, "Intercept"] <- ARIMA$coef["intercept"]
    COEFFICIENTS[m, 1:x_count] <- ARIMA$coef[colnames(x_vars)]
    
    STANDARD_ERRORS[m, "Intercept"] <- ARIMA_SE[c("intercept"),1]
    STANDARD_ERRORS[m, 1:x_count] <- ARIMA_SE[c(colnames(x_vars)),1]
    
    P_VALUES[m, "Intercept"] <- TEMP_P[c("intercept"),1]
    P_VALUES[m, 1:x_count] <- TEMP_P[c(colnames(x_vars)),1]
    
    RESIDUALS[m, "AIC"] <- ARIMA$aic 
    RESIDUALS[m, "SSE"] <- sum(TEMP_R)
    RESIDUALS[m, "MSE"] <- mean(TEMP_R)
    TEMP_LB <- Box.test(TEMP_R, lag=length(TEMP_R)-1, type="Ljung-Box", fitdf = AR + MA)
    RESIDUALS[m, "Ljung-Box P-Value"] <- TEMP_LB$p.value
    TEMP_SW <- shapiro.test(TEMP_R)
    RESIDUALS[m, "Shapiro-Wilk P-Value"] <- TEMP_SW$p.value
    
  }
  
  #-------------------------------------------------------------------------------------------------------------------------------#
  # ADD SUFFIXES TO COLUMN NAMES AND AN INDEX FOR JOINING TO CREATE FULL ARIMA RESULTS
  #-------------------------------------------------------------------------------------------------------------------------------#
  
  colnames(STANDARD_ERRORS) <- paste("SE", colnames(STANDARD_ERRORS), sep=" ")
  colnames(P_VALUES) <- paste("P-VAL", colnames(P_VALUES), sep=" ")
  colnames(COEFFICIENTS) <- paste("EST", colnames(COEFFICIENTS), sep=" ")
  
  MODELS["Index"] <- as.numeric(row.names(MODELS))
  COEFFICIENTS["Index"] <- as.numeric(row.names(COEFFICIENTS))
  STANDARD_ERRORS["Index"] <- as.numeric(row.names(STANDARD_ERRORS))
  P_VALUES["Index"] <- as.numeric(row.names(P_VALUES))
  RESIDUALS["Index"] <- as.numeric(row.names(RESIDUALS))
  
  ARIMA_RESULTS <- merge(MODELS, COEFFICIENTS, by = "Index")
  ARIMA_RESULTS <- merge(ARIMA_RESULTS, STANDARD_ERRORS, by="Index")
  ARIMA_RESULTS <- merge(ARIMA_RESULTS, P_VALUES, by="Index")
  ARIMA_RESULTS <- merge(ARIMA_RESULTS, RESIDUALS, by="Index")
  
  return(ARIMA_RESULTS)
  
}
