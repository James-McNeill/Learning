# Pipelines and ensembles
# How to use pipelines to make your code clearer and easier to maintain. Then you'll use cross-validation to better 
# test your models and select good model parameters. Finally you'll dabble in two types of ensemble model.

# A. Pipeline
# 1. Flight duration model: Pipeline stages
# Convert categorical strings to index values
indexer = StringIndexer(inputCol='org', outputCol='org_idx')

# One-hot encode index values
onehot = OneHotEncoderEstimator(
    inputCols=['org_idx', 'dow'],
    outputCols=['org_dummy', 'dow_dummy']
)

# Assemble predictors into a single column
assembler = VectorAssembler(inputCols=['km', 'org_dummy', 'dow_dummy'], outputCol=['features'])

# A linear regression object
regression = LinearRegression(labelCol='duration')
