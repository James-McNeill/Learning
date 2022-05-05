# Website: https://github.com/tirthajyoti/Machine-Learning-with-Python/blob/master/Pandas%20and%20Numpy/Matplotlib_Seaborn_basics.ipynb
# Basics of Matplotlib and Seaborn 

#%% Matplotlib
# Scatterplot - basic
people = ['Ann','Brandon','Chen','David','Emily','Farook',
          'Gagan','Hamish','Imran','Julio','Katherine','Lily']
age = [21,12,32,45,37,18,28,52,5,40,48,15]
weight = [55,35,77,68,70,60,72,69,18,65,82,48]
height = [160,135,170,165,173,168,175,159,105,171,155,158]

import matplotlib.pyplot as plt

plt.scatter(age, height)
plt.show()

#%% Scatterplot - adding bells and whistles
# set figure size
plt.figure(figsize=(8,6))
# Add a main title
plt.title("Plot of Age vs. Height (in cms)\n", fontsize=20, fontstyle='italic')
# X and Y label with fontsize
plt.xlabel("Age (years)", fontsize=16)
plt.ylabel("Height (cms)", fontsize=16)
# Turn on grid
plt.grid (True)
# Set y axis limit
plt.ylim(100,200)
# X and Y axis ticks custimisation with fontsize and placement
plt.xticks([i*5 for i in range(12)], fontsize=15)
plt.yticks(fontsize=15)
# Main plotting function with choice of color, marker size, and marker edge color
plt.scatter(x=age,y=height,c='orange',s=150,edgecolors='k')

# Adding bit of text to the plot
plt.text(x=15,y=105,s="Height increases up to around \n20 years and then tapers off",fontsize=15, 
         rotation=30, linespacing=2)
plt.text(x=22,y=185,s="Nobody has a height beyond 180 cm",fontsize=15)

# Adding a vertical line
plt.vlines(x=20,ymin=100,ymax=180,linestyles='dashed',color='blue',lw=3)

# Adding a horizontal line
plt.hlines(y=180,xmin=0,xmax=55,linestyles='dashed',color='red',lw=3)

# Adding a legend
plt.legend(['Height in cms'],loc=2,fontsize=14)

# Final show method
plt.show()

#%% Bar chart
plt.figure(figsize=(12,4))
plt.title("People's weight in kgs",fontsize=16, fontstyle='italic')
# Main plot function 'bar'
plt.bar(x=people,height=weight, width=0.6,color='orange',edgecolor='k',alpha=0.6)
plt.xlabel("People",fontsize=15)
plt.xticks(fontsize=14,rotation=30)
plt.yticks(fontsize=14)
plt.ylabel("Weight (in kgs)",fontsize=15)
plt.show()

#%% Histogram
import numpy as np
plt.figure(figsize=(7,5))
# Main plot function 'hist'
plt.hist(weight,color='red',edgecolor='k', alpha=0.75,bins=5)
plt.title("Histogram of patient weight",fontsize=18)
plt.xlabel("Weight in kgs",fontsize=15)
plt.xticks(fontsize=15)
plt.yticks(fontsize=15)
plt.show()

#%% Simple line plot
days = np.arange(1,31) # create a range with values from 1 to 30
candidate_A = 50+days*0.07+2*np.random.randn(30)
candidate_B = 50-days*0.1+3*np.random.randn(30)

# Determine the minimum and maximum of stock prices
ymin = min(candidate_A.min(),candidate_B.min())
ymax = max(candidate_A.max(),candidate_B.max())

# Set style
plt.style.use('fivethirtyeight')

plt.figure(figsize=(12,5))
plt.title("Time series plot of poll percentage over a month\n",fontsize=20, fontstyle='italic')
plt.xlabel("Days",fontsize=16)
plt.ylabel("Poll percentage (%)",fontsize=16)
plt.grid (True)
plt.ylim(ymin*0.98,ymax*1.02)
plt.xticks([i*2 for i in range(16)],fontsize=14)
plt.yticks(fontsize=15)

# Main plotting function - plot (note markersize, lw (linewidth) arguments)
plt.plot(days,candidate_A,'o-',markersize=10,c='blue',lw=2)
plt.plot(days,candidate_B,'^-',markersize=10,c='green',lw=2)

plt.legend(['Poll percentage of candidate A (%)', 'Poll percentage of candidate B (%)'],loc=2,fontsize=14)
plt.show()

#%% Boxplot
plt.style.use('ggplot')
# Note how to convert default numerical x-axis ticks to the list of string by passing two lists 
plt.boxplot(x=[candidate_A,candidate_B],showmeans=True)
plt.grid(True)
plt.xticks([1,2],['Candidate A','Candidate B'])
#plt.yticks(fontsize=15)
plt.show()

#%% Pandas DataFrames support some visualisations directly
# Dataset is taking from UCI website: https://archive.ics.uci.edu/ml/datasets/wine

import pandas as pd
df = pd.read_csv('winedata.csv')
df.head()

# Set the matplotlib style to default
import matplotlib as mpl
mpl.rcParams.update(mpl.rcParamsDefault)

#%% Scatterplot

import matplotlib.pyplot as plt
df.plot.scatter('Alcohol','Color intensity')
plt.show()

#%% Histogram
df['Alcohol'].plot.hist(bins=20,figsize=(5,5),edgecolor='k')
plt.xlabel('Alcohol percentage')
plt.show()

#%% Seaborn - advanced statistical visualisations
import seaborn as sns

# Boxplot separated by class/groups of data
sns.boxplot(x='Class', y='Alcohol', data=df)
plt.show()
#%% Violin plots (combination of boxplot and histogram/kernel density)
sns.violinplot(x='Class', y='Alcohol', data=df)
plt.show()
#%% Regplot - computes and plots the linear regression fit along with confidence interval
sns.regplot(x='Alcohol', y='Color intensity', data=df)
plt.show()
#%% lmplot - combination of regplot with grid to visualise across various groups/classes
sns.lmplot(x='Alcohol',y='Color intensity',hue='Class',data=df)
plt.show()

#%% Correlation matrix and heatmap
import numpy as np
corr_mat=np.corrcoef(df,rowvar=False)
corr_mat.shape

corr_df = pd.DataFrame(corr_mat,columns=df.columns,index=df.columns)
print(np.round(corr_mat,3))

sns.heatmap(corr_df,linewidth=1,cmap='plasma')
plt.show()
