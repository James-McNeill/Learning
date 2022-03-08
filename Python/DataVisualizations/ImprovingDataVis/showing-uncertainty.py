# Showing uncertainty
# Uncertainty occurs everywhere in data science, but it's frequently left out of visualizations where it should be included. 
# Here, we review what a confidence interval is and how to visualize them for both single estimates and continuous functions. 
# Additionally, we discuss the bootstrap resampling technique for assessing uncertainty and how to visualize it properly

# A. Point estimate intervals
# 1. Basic confidence intervals
# Construct CI bounds for averages
average_ests['lower'] = average_ests['mean'] - 1.96*average_ests['std_err']
average_ests['upper'] = average_ests['mean'] + 1.96*average_ests['std_err']

# Setup a grid of plots, with non-shared x axes limits
g = sns.FacetGrid(average_ests, row = 'pollutant', sharex = False)

# Plot CI for average estimate
g.map(plt.hlines, 'y', 'lower', 'upper')

# Plot observed values for comparison and remove axes labels
g.map(plt.scatter, 'seen', 'y', color = 'orangered').set_ylabels('').set_xlabels('') 

plt.show()

