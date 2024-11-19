# -*- coding: utf-8 -*-
"""
Created on Wed Jun 28 09:40:37 2023

@author: jamesmcneill
# Building a dash app
# Aim: baseline output using the iris dataset
# 1) Data engineering steps
# 2) Classification model
# 3) Data visualization

# For testing going to break out into code blocks
"""

import dash
from dash import dcc
from dash import html
from dash.dependencies import Input, Output
import pandas as pd
import plotly.express as px
from sklearn.datasets import load_iris
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score

# Load the Iris dataset
iris = load_iris()
df = pd.DataFrame(data=iris.data, columns=iris.feature_names)
df['target'] = iris.target

# Train a Random Forest Classifier
model = RandomForestClassifier()
model.fit(df[iris.feature_names], df['target'])

# Initialize the Dash application
app = dash.Dash(__name__)

# Define the layout of the Dash application
app.layout = html.Div([
    html.H1('Iris Flower Classification'),
    
    # Data Engineering Output
    html.H2('Data Engineering Output'),
    html.Div(id='data-engineering-output'),
    
    # Model Comparison Visualization
    html.H2('Model Comparison'),
    dcc.Graph(id='model-comparison'),
    
    # Model Accuracy Output
    html.H3('Model Accuracy:'),
    html.Div(id='accuracy-output')
    ])

# Data Engineering Output Callback
@app.callback(Output('data-engineering-output', 'children'), [])
def data_engineering_output():
    return html.Pre(df.head().to_string())

# Model Comparison Callback
@app.callback(Output('model-comparison', 'figure'), [])
def model_comparison():
    # Generate figure
    fig = px.scatter(df, x='sepal length (cm)', y='sepal width (cm)', color='target')
    return fig

# Accuracy Output Callback
@app.callback(Output('accuracy-output', 'children'), [])
def accuracy_output():
    # Calculate accuracy for the trained model
    y_pred = model.predict(df[iris.feature_names])
    accuracy = accuracy_score(df['target'], y_pred)
    return html.Pre(f'{accuracy: .2%}')

# Run the Dash application
if __name__ == '__main__':
    app.run_server(debug=True)
