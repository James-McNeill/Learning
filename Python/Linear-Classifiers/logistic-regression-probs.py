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

# Example: review the handwritten digit dataset and compare the most and least predictive digits
lr = LogisticRegression()
lr.fit(X,y)

# Get predicted probabilities
proba = lr.predict_proba(X)

# Sort the example indices by their maximum probability
proba_inds = np.argsort(np.max(proba,axis=1))

# Show the most confident (least ambiguous) digit - shows the highest probability prediction
show_digit(proba_inds[-1], lr)

# Show the least confident (most ambiguous) digit - shows the lowest probability prediction
show_digit(proba_inds[0], lr)
