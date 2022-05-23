# Make model prediction from pipeline

# Creating a submission from the pipeline
holdout = pd.read_csv('HoldoutData.csv', index_col=0)

predictions = pl.predict_proba(holdout)

prediction_df = pd.DataFrame(columns=pd.get_dummies(df[LABELS]).columns, index=holdout.index,data=predictions)

prediction_df.to_csv('predictions.csv')

score = score_submission(pred_path='predictions.csv')
