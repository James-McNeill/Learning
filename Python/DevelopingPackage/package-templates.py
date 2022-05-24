# Package Templates

'''
Using cookiecutter
cookiecutter https://github.com/audreyr/cookiecutter-pypackage
Make sure to switch off the command line interface.
Cookie cutter will fill everything out
'''

# Changing details to the initial setup file
full_name [Audrey Roy Greenfeld]: James McNeill
email []: useremail
github_username []:
project_name [Python Boilerplate]: package_name
project_slug [] : package_name
  
# Files from templates
'''
CONTRIBUTION.md
How users can help to contribute and how to get in touch. 
HISTORY.md
Shows the history of code changes. 
1) Improvements, 2) New additions, 3) Bugs, 4) Deprecated
'''

# Update version of package
'''
Can use the bumpversion with the three arguments of; 1) Major, 2) Minor and 3) Patch. Using this in the 
terminal ensures that all the key areas within the packages have their version number updated accordingly.
'''

# Building package website
'''
Help for creating the documentation that will relate to the package's. Go to 1) ReadtheDocs or 2) Sphinx
'''

# Makefile
'''
This file can store all of the code that is required to be run within the terminal. It helps to store all of the terminal options required.
To help with creating this file use 'make help' in terminal.
'''
