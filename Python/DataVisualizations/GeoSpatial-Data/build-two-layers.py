# Building 2-layer maps : combining polygons and scatterplots

# A. Introduction
# 1. Styling a scatterplot
# Import matplotlib.pyplot
import matplotlib.pyplot as plt

# Scatterplot 1 - father heights vs. son heights with darkred square markers
plt.scatter(father_son.fheight, father_son.sheight, c = 'darkred', marker = 's')

# Show your plot
plt.show()

# Scatterplot 2 - yellow markers with darkblue borders
plt.scatter(father_son.fheight, father_son.sheight, c = 'yellow', edgecolor = 'darkblue')

# Show the plot
plt.show()

# Scatterplot 3
plt.scatter(father_son.fheight, father_son.sheight,  c = 'yellow', edgecolor = 'darkblue')
plt.grid()
plt.xlabel('father height (inches)')
plt.ylabel('son height (inches)')
plt.title('Son Height as a Function of Father Height')

# Show your plot
plt.show()

# 2. Extracting longitude and latitude
# print the first few rows of df 
print(df.head())

# extract latitude to a new column: lat
df['lat'] = [loc[0] for loc in df.Location]

# extract longitude to a new column: lng
df['lng'] = [loc[1] for loc in df.Location]

# print the first few rows of df again
print(df.head())

# 3. 
