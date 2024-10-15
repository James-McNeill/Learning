# Reviewing movements
def var_movement(df, var_cm, var_pm, loan_no='Loan_No', exclude_zeros=False):
    """
    Analyzes movements between two variables and identifies significant changes.

    This function calculates the movement between two specified columns in the DataFrame
    (`var_cm` and `var_pm`) and filters the results based on their deviations from the mean.
    It can optionally exclude rows where either of the specified columns is zero.

    Parameters:
    df (pd.DataFrame): The input DataFrame containing the data.
    var_cm (str): The name of the column representing the current value.
    var_pm (str): The name of the column representing the previous value.
    loan_no (str, optional): The name of the column representing loan numbers. Defaults to 'Loan_No'.
    exclude_zeros (bool, optional): If True, excludes rows where var_cm or var_pm are zero. Defaults to False.

    Returns:
    tuple: Two DataFrames containing significant movements:
        - significant_movements_one_sd: Movements greater than one standard deviation from the mean.
        - significant_movements_two_sd: Movements greater than two standard deviations from the mean.
    
    Visuals:
    Displays a histogram of the movements with lines indicating one and two standard deviations,
    as well as a QQ plot to assess the normality of the movements.
    """
    
    # Calculate the val_move variable as the difference between var_cm and var_pm
    df['val_move'] = df[var_cm] - df[var_pm]

    # Optionally exclude rows where var_cm or var_pm are zero
    if exclude_zeros:
        df = df[(df[var_cm] != 0) & (df[var_pm] != 0)]

    # Calculate mean and standard deviation
    mean = df['val_move'].mean()
    std_dev = df['val_move'].std()

    print(f'Mean: {mean}, Standard Deviation: {std_dev}')

    # Use .loc to filter for significant movements using one and two standard deviations
    significant_movements_one_sd = df.loc[
        (df['val_move'] > (mean + std_dev)) | (df['val_move'] < (mean - std_dev)),
        [loan_no, 'val_move', var_cm, var_pm]
    ].dropna().sort_values(by='val_move')

    significant_movements_two_sd = df.loc[
        (df['val_move'] > (mean + 2 * std_dev)) | (df['val_move'] < (mean - 2 * std_dev)),
        [loan_no, 'val_move', var_cm, var_pm]
    ].dropna().sort_values(by='val_move')

    # Plotting
    plt.figure(figsize=(12, 6))
    
    # Histogram and KDE with trimmed data
    sns.histplot(df['val_move'], bins=30, kde=True, color='lightgray', label='Distribution of val_move', stat='density')
    
    # Limit the x-axis for better visualization
    plt.xlim(mean - 4 * std_dev, mean + 4 * std_dev)

    # Add vertical lines for one and two standard deviations
    plt.axvline(mean + std_dev, color='blue', linestyle='--', label='Mean + 1 SD')
    plt.axvline(mean - std_dev, color='blue', linestyle='--', label='Mean - 1 SD')
    plt.axvline(mean + 2 * std_dev, color='red', linestyle='--', label='Mean + 2 SD')
    plt.axvline(mean - 2 * std_dev, color='red', linestyle='--', label='Mean - 2 SD')

    plt.title('Histogram of val_move with Standard Deviations')
    plt.legend()

    # QQ Plot
    plt.figure(figsize=(12, 6))
    stats.probplot(df['val_move'], dist="norm", plot=plt)
    plt.title('QQ Plot of val_move')
    
    plt.tight_layout()
    plt.show()

    # Return the significant movements DataFrames
    return significant_movements_one_sd, significant_movements_two_sd

# Example usage:
# df = pd.read_csv('your_data.csv')
# one_sd_df, two_sd_df = var_movement(df, 'val_cm', 'val_pm', exclude_zeros=True)
