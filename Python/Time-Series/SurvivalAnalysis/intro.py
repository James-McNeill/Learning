# Introduction to survival analysis

# Preprocess censored data
# Create a function to return 1 if observed 0 otherwise. As we are not able to observe these two events then they are flagged as not observed
def check_observed(row):
    if pd.isna(row['birth_date']):
        flag = 0
    elif pd.isna(row['death_date']):
        flag = 0
    else:
        flag = 1
    return flag
  
# Create a censorship flag column
dolphin_df['observed'] = dolphin_df.apply(check_observed, axis=1)

# Print average of observed
print(np.average(dolphin_df['observed']))

# Reviewing censored data to understand if the analysis can be done
# Print first row
print(regime_durations.head(1))

# Count censored data
count = len(regime_durations[regime_durations['observed'] == 0])

# Print the count to console. Rule of thumb, should more than 50% of the data be censored then another form of analysis would make more sense
print(count)

# Draw a survival curve
# Plot the survival function
prison_kmf.plot_survival_function()

# Show the plot
plt.show()

# Reviewing the survival model
from lifelines import KaplanMeierFitter
import pandas as pd
import matplotlib.pyplot as plt

# Instantiate a KaplanMeierFitter object kmf
kmf = KaplanMeierFitter()

# Fit the KaplanMeierFitter object to the data
kmf.fit(durations=regime_durations['duration'], 
        event_observed=regime_durations['observed'])

# Visualize and show the survival curve
kmf.plot_survival_function()
plt.show()

