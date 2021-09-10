# As you probably noticed, smaller values of C lead to less confident predictions. 
# That's because smaller C means more regularization, which in turn means smaller coefficients, 
# which means raw model outputs closer to zero and, thus, 
# probabilities closer to 0.5 after the raw model output is squashed through the sigmoid function.

# Set the regularization strength
model = LogisticRegression(C=1)

# Fit and plot
model.fit(X,y)
plot_classifier(X,y,model,proba=True)

# Predict probabilities on training points
prob = model.predict_proba(X)
print("Maximum predicted probability", np.max(prob))

# Set the regularization strength
model = LogisticRegression(C=0.1)

# Fit and plot
model.fit(X,y)
plot_classifier(X,y,model,proba=True)

# Predict probabilities on training points
prob = model.predict_proba(X)
print("Maximum predicted probability", np.max(prob))
