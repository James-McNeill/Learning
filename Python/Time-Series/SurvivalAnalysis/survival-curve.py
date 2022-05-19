# Survival curve estimation

# Fit a Kaplan-Meier (KM) estimate
# Good first model to understand time to events. More advanced models required to understand covariance
# Print first row
print(has_pericardial_effusion.head(1))

# Instantiate Kaplan Meier object for patients with and without pericardial effusion
kmf_has_pe = KaplanMeierFitter()
kmf_no_pe = KaplanMeierFitter()

# Fit Kaplan Meier estimators to each DataFrame
kmf_has_pe.fit(durations=has_pericardial_effusion['survival'], 
          event_observed=has_pericardial_effusion['observed'])
kmf_no_pe.fit(durations=none_pericardial_effusion['survival'], 
          event_observed=none_pericardial_effusion['observed'])

# Print out the median survival duration of each group. There are many attributes available from the fitted model
print("The median survival duration (months) of patients with pericardial effusion: ", kmf_has_pe.median_survival_time_)
print("The median survival duration (months) of patients without pericardial effusion: ", kmf_no_pe.median_survival_time_)

# Plotting the survival curve
# There are a number of options available to use after fitting the kmf
senator_kmf.plot_survival_function()
senator_kmf.survival_function_.plot()
senator_kmf.plot()

# Calculate duration
recur['duration'] = recur['time_1'] - recur['time_0']

# Instantiate and fit KaplanMeierFitter
kmf = KaplanMeierFitter()
kmf.fit(recur['duration'], recur['censor'])

# Plot survival function with CI
kmf.plot_survival_function()

# Display figure
plt.show()

# Fit Kaplan-Meier estimator
kmf.fit(bc_df['diff_days'], bc_df['observed'], label='British Columbia')

# Plot survival function on senator_fig
kmf.plot(ax=senator_fig)

# Display the figure. Large confidence intervals show that the sample size is small and that the 95% CI is wider. For a larger sample size the CI is smaller
plt.show()

# Comparing treatment groups
# Mask for new treatment. Creating a Boolean mask
new = (recur['treat'] == 0)

# Fit to new treatment and plot survival function
kmf.fit(recur[new]['duration'], recur[new]['censor'], label='New treatment')
kmf.plot_survival_function(ax=ax)

# Fit to old treatment and plot survival function
kmf.fit(recur[new == False]['duration'], recur[new == False]['censor'], label='Old treatment')
kmf.plot_survival_function(ax=ax)

# Display figure
plt.show()
