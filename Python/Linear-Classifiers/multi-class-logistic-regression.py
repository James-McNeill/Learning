# There are two types of multi-class logistic regression, one-vs-rest and softmax/multinomial
# One-vs-rest is the standard logisitc regression. When fitting too a multi-class we could fit
# multiple binary logisitic regressions and then take the highest probability as the prediction.
# Alternatively, we could perform the same model task with a single multinomial logistic regression.
# The same probabilities should be predicted for each of the classes.

# Fit one-vs-rest logistic regression classifier
lr_ovr = LogisticRegression()
lr_ovr.fit(X_train, y_train)

print("OVR training accuracy:", lr_ovr.score(X_train, y_train))
print("OVR test accuracy    :", lr_ovr.score(X_test, y_test))

# Fit softmax classifier
lr_mn = LogisticRegression(
    multi_class='multinomial',
    solver="lbfgs",
)
lr_mn.fit(X_train, y_train)

print("Softmax training accuracy:", lr_mn.score(X_train, y_train))
print("Softmax test accuracy    :", lr_mn.score(X_test, y_test))

# The accuracy of the two models is fairly similar

# Example: Visualizing multi-class logistic regression
# Print training accuracies
print("Softmax     training accuracy:", lr_mn.score(X_train, y_train))
print("One-vs-rest training accuracy:", lr_ovr.score(X_train, y_train))

# Create the binary classifier (class 1 vs. rest)
lr_class_1 = LogisticRegression(C=100)
lr_class_1.fit(X_train, y_train==1)

# Plot the binary classifier (class 1 vs. rest) - One-vs-rest did not fit the classes well but usually it can
plot_classifier(X_train, y_train==1, lr_class_1)

# One-vs-rest SVM - scikit-learn's SVC object, which is a non-linear "kernel" SVM
# We'll use SVC instead of LinearSVC from now on
from sklearn.svm import SVC

# Create/plot the binary classifier (class 1 vs. rest)
svm_class_1 = SVC()
svm_class_1.fit(X_train, y_train==1)
plot_classifier(X_train, y_train==1, svm_class_1)

# The SVC classifier works well as it is able to perform a non-linear method of surrounding the class values to
# perform a better prediction. A circle was placed around the class being predicted compared to a straight line
# boundary which would be seen with the LogisiticRegression
