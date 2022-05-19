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
# Fit to fin == 0
kmf.fit(durations=prison[prison["fin"] == 0]["week"], 
        event_observed=prison[prison["fin"] == 0]["arrest"])

# Plot survival curve for fin == 0
ax = kmf.plot()

# Fit to fin == 1 and plot on ax
kmf.fit(durations=prison[prison["fin"] == 1]["week"], 
        event_observed=prison[prison["fin"] == 1]["arrest"])
kmf.plot(ax=ax)
plt.show()

# Test the PH assumption automatically
# Check PH assumption
print(cph.check_assumptions(training_df=prison, p_value_threshold=0.1))

# Employee churn study
# Instantiate a CoxPHFitter object cph
cph = CoxPHFitter()

# Fit cph on all covariates
cph.fit(employees, 'years_at_company', event_col='attrition')

# Select employees that have not churned
current_employees = employees.loc[employees['attrition'] == 0]

# Existing durations of employees that have not churned
current_employees_last_obs = current_employees['years_at_company']

# Predict survival function conditional on existing durations
cph.predict_survival_function(current_employees, 
                              conditional_after=current_employees_last_obs)

# Predict median remaining times for current employees
pred = cph.predict_median(current_employees, 
                              conditional_after=current_employees_last_obs)

# Print the smallest median remaining time
print(min(pred))
