# Display the difference between Linear and Non-Linear classifier decision boundaries
from sklearn.linear_model import LogisticRegression
from sklearn.svm import SVC, LinearSVC
from sklearn.neighbors import KNeighborsClassifier

# Define the classifiers
classifiers = [LogisticRegression(), LinearSVC(), SVC(), KNeighborsClassifier()]

# Fit the classifiers
for c in classifiers:
    c.fit(X, y)

# Plot the classifiers - https://github.com/UBC-CS/cpsc340/blob/master/lectures/plot_classifier.py
plot_4_classifiers(X, y, classifiers)
plt.show()
