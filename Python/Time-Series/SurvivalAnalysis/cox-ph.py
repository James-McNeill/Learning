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
