# Create function for the correlation metric
def my_pearsonr(est, X, y):
  # Generate predictions and convert to a vector     
  y_pred = est.predict(X).squeeze()
  
  # Use the numpy "corrcoef" function to calculate a correlation matrix    
  my_corrcoef_matrix = np.corrcoef(y_pred, y.squeeze())
  
  # Return a single correlation value from the matrix    
  my_corrcoef = my_corrcoef[1, 0]
  return my_corrcoef
