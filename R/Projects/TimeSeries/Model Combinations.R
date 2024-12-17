MODEL_COMBINATIONS <- function(data_in, comb){
  
  temp <- data.frame(colnames(data_in))
  colnames(temp) <- c("X1")
  
  MODELS1 <- temp
  data_names <- c("MODELS1") 
  

  
  if(comb > 1){
    for(i in 2:comb){
      
      temp1 <- temp
      colnames(temp1) <- paste("X", i, sep = "")
      
      temp2 <- merge(get(data_names[i-1]), temp1, all = TRUE)
      
      assign(paste("MODELS", i), temp2)
      
      data_names[i] <- paste("MODELS", i)
      
    }
  }
  
  for(i in 1:comb){
    
    if(i == 1){
      
      MODELS <- get(data_names[i])
      
    }
    else{
      
      MODELS <- rbind.fill(MODELS, get(data_names[i]))
      
    }
    
  }
  
  
  return(MODELS)
  
}


MODEL_EXCLUSIONS <- function(data_in, comb){
  
  for(i in 2:comb){
    
    for(j in 1:(i-1)){
      
      data_in <- data_in[data_in[,j] != data_in[,i]| is.na(data_in[,i]) | is.na(data_in[,j]) ,]
      
    }
    
  }
  
  temp <- data.frame(matrix(data = NA, nrow = nrow(data_in), ncol = 1))
  
  for(i in 1:nrow(data_in)){
    
    char <- paste(sort(as.character(unlist(data_in[i, 1:comb]))), collapse = " ")
    temp[i,1] <- char
    
  }
  
  dups <- duplicated(temp) == FALSE
  data_in <- data_in[c(dups),]
  
  rownames(data_in) <-1:nrow(data_in)
  return(data_in)
  
}

MODEL_ARMA <- function(data_in, p, q){
  
  AR <- data.frame("AR"=0:p)
  MA <- data.frame("MA"=0:q)
  
  data_out <- merge(data_in, AR, all=TRUE)
  data_out <- merge(data_out,MA, all=TRUE)
}
