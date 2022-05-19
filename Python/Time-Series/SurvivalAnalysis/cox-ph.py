# Cox Proportional Hazards (PH) model

# Model prison data with PH model
# Import CoxPHFitter class
from lifelines import CoxPHFitter

# Instantiate CoxPHFitter class cph
cph = CoxPHFitter()

# Fit cph to data
cph.fit(df=prison, duration_col="week", event_col="arrest")

# Print model summary
print(cph.summary)

# Instantiate CoxPHFitter class
custom_cph = CoxPHFitter()

# Fit custom model
custom_cph.fit(df=prison, duration_col="week", event_col="arrest", formula="fin + age + prio")

# Print model summary
print(custom_cph.summary)

# Instantiate CoxPHFitter class
cph = CoxPHFitter()

# Fit cph to data using all columns
cph.fit(df=prison, duration_col="week", event_col="arrest")

# Assign summary to summary_df
summary_df = cph.summary

# Create new column of survival time ratios
summary_df["surv_ratio"] = 1 / np.exp(summary_df['coef'])

# Print surv_ratio for prio
print(summary_df.loc['prio', "surv_ratio"])

# Plot partial effects
cph.plot_partial_effects_on_outcome(covariates=["fin", "age", "wexp", "mar","paro", "prio"],
         values=[[0, 35, 0, 1, 1, 3], [1, 22, 0, 0, 0, 0]])

# Show plot
plt.show()

# Test the PH assumptions
