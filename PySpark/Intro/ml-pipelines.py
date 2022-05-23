# ML pipelines with Spark

'''
At the core of the pyspark.ml module are the Transformer and Estimator classes. Almost every other class in the module behaves 
similarly to these two basic classes.

Transformer classes have a .transform() method that takes a DataFrame and returns a new DataFrame; usually the original one with 
a new column appended. For example, you might use the class Bucketizer to create discrete bins from a continuous feature or the 
class PCA to reduce the dimensionality of your dataset using principal component analysis.

Estimator classes all implement a .fit() method. These methods also take a DataFrame, but instead of returning another DataFrame 
they return a model object. This can be something like a StringIndexerModel for including categorical data saved as strings in 
your models, or a RandomForestModel that uses the random forest algorithm for classification or regression.
Before you get started modeling, it's important to know that Spark only handles numeric data. That means all of the columns in 
your DataFrame must be either integers or decimals (called 'doubles' in Spark).

When we imported our data, we let Spark guess what kind of information each column held. Unfortunately, Spark doesn't always 
guess right and you can see that some of the columns in our DataFrame are strings containing numbers as opposed to actual numeric values.

To remedy this, you can use the .cast() method in combination with the .withColumn() method. It's important to note that .cast() 
works on columns, while .withColumn() works on DataFrames.
'''
# Cast the columns to integers
model_data = model_data.withColumn("arr_delay", model_data.arr_delay.cast("integer"))
model_data = model_data.withColumn("air_time", model_data.air_time.cast("integer"))
model_data = model_data.withColumn("month", model_data.month.cast("integer"))
model_data = model_data.withColumn("plane_year", model_data.plane_year.cast("integer"))
# Create the column plane_age
model_data = model_data.withColumn("plane_age", model_data.year - model_data.plane_year)

# Create is_late
model_data = model_data.withColumn("is_late", model_data.arr_delay > 0)

# Convert to an integer
model_data = model_data.withColumn("label", model_data.is_late.cast("integer"))

# Remove missing values
model_data = model_data.filter("arr_delay is not NULL and dep_delay is not NULL and air_time is not NULL and plane_year is not NULL")

# Create a StringIndexer
carr_indexer = StringIndexer(inputCol="carrier", outputCol="carrier_index")

# Create a OneHotEncoder
carr_encoder = OneHotEncoder(inputCol="carrier_index", outputCol="carrier_fact")
# Create a StringIndexer
dest_indexer = StringIndexer(inputCol="dest", outputCol="dest_index")

# Create a OneHotEncoder
dest_encoder = OneHotEncoder(inputCol="dest_index", outputCol="dest_fact")
# Make a VectorAssembler - pipeline method. All of these dummy variables are combined together into one large vector
vec_assembler = VectorAssembler(inputCols=["month", "air_time", "carrier_fact", "dest_fact", "plane_age"], outputCol="features")


# Create the Pipeline
'''
Pipeline is a class in the pyspark.ml module that combines all the Estimators and Transformers that you've already created. This 
lets you reuse the same modeling process over and over again by wrapping it up in one simple object.
'''
# Import Pipeline
from pyspark.ml import Pipeline

# Make the pipeline
flights_pipe = Pipeline(stages=[dest_indexer, dest_encoder, carr_indexer, carr_encoder, vec_assembler])
# Fit and transform the data
piped_data = flights_pipe.fit(model_data).transform(model_data)
# Split the data into training and test sets
training, test = piped_data.randomSplit([.6, .4])


# Model tuning and selection
'''
Performing model evaluation using k-fold cross validation. It works by splitting the training data into a few different partitions. 
The exact number is up to you, but in this course you'll be using PySpark's default value of three.

# Fit cross validation models
models = cv.fit(training)

# Extract the best model
best_lr = models.bestModel
Due to the number of cross validation computations that would be required to fit the model, the cross validator instance has not
been used. The setup for creating it has only been displayed.
'''
# Import LogisticRegression
from pyspark.ml.classification import LogisticRegression

# Create a LogisticRegression Estimator
lr = LogisticRegression()
# Import the evaluation submodule
import pyspark.ml.evaluation as evals

# Create a BinaryClassificationEvaluator
evaluator = evals.BinaryClassificationEvaluator(metricName="areaUnderROC")
# Import the tuning submodule
import pyspark.ml.tuning as tune

# Create the parameter grid
grid = tune.ParamGridBuilder()

# Add the hyperparameter
grid = grid.addGrid(lr.regParam, np.arange(0, .1, .01))
grid = grid.addGrid(lr.elasticNetParam, [0, 1])

# Build the grid
grid = grid.build()
# Create the CrossValidator
cv = tune.CrossValidator(estimator=lr,
               estimatorParamMaps=grid,
               evaluator=evaluator
               )
# Call lr.fit()
best_lr = lr.fit(training)

# Print best_lr
print(best_lr)
# Use the model to predict the test set
test_results = best_lr.transform(test)

# Evaluate the predictions
print(evaluator.evaluate(test_results))
