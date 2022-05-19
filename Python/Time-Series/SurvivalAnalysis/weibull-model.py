# Weibull model
# Parametric model used to fit a survival curve

# Two key model inputs are k and lambda
# k: determines the shape
# lambda: determines the scale. relates to the point on the distribution were 63.2% of the population have experienced the event

# Model prison data
# Import WeibullFitter class
from lifelines import WeibullFitter

# Instantiate WeibullFitter class wb
wb = WeibullFitter()

# Fit data to wb
wb.fit(durations=prison['week'], event_observed=prison['arrest'])

# Plot survival function
wb.survival_function_.plot()
plt.show()

# Compare weibull model parameters
# Mask for parole
parole = (prison['paro'] == 1)

# Fit to parolee data
wb.fit(durations=prison[parole]['week'], event_observed=prison[parole]['arrest'])

# Print rho
print("The rho_ parameter of parolee survival function is: ", wb.rho_)

# Fit to non parolee
wb.fit(durations=prison[parole == False]['week'], event_observed=prison[parole == False]['arrest'])

# Print rho
print("The rho_ parameter of non-parolee survival function is: ", wb.rho_)

# Import WeibullAFTFitter and instantiate
from lifelines import WeibullAFTFitter
aft = WeibullAFTFitter()

# Fit heart_patients data into aft
aft.fit(heart_patients, duration_col='survival', event_col='observed')

# Print the summary
print(aft.summary)

# Calculate the exponential of EPSS coefficient
exp_epss = np.exp(aft.params_.loc['lambda_'].loc['epss'])
print('When EPSS increases by 1, the average survival duration changes by a factor of ', exp_epss)

# Adding interaction terms within the formula
# Fit custom model
aft.fit(heart_patients, 
        duration_col='survival', 
        event_col='observed',
        formula='epss + gender_f * lvdd')

# Print model summary
print(aft.summary)

# Visualization and prediction
# Fit data to aft
aft.fit(df=prison,
        duration_col='week',
        event_col='arrest')

# Plot partial effects of prio. Show comparison of models with these variable parameters applied. The baseline model line is the original model
aft.plot_partial_effects_on_outcome(covariates='prio', values=[0, 3, 5, 8])
plt.show()

# Predict re-arrest rate
# Predict median of new data
aft_pred = aft.predict_median(prison_new)

# Print average predicted time to arrest
print("On average, the median number of weeks for new released convicts to be arrested is: ", np.mean(aft_pred))
