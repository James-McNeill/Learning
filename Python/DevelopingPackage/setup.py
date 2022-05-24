# setup

'''
Overview of how the setup file should be defined. Helps to provide other users with the key details on the package. 
To work with an editable version of the package (if developing/amending/editing) features, use "pip install -e" to enter edit mode
'''
# Import required functions
from setuptools import setup, find_packages

# Call setup function
setup(
  author = "First Last",
  description = "High level single line on package",
  name = "packageName",
  version = "0.1.0",
  packages=find_packages(include=["packageName","packageName.*"]),
)
