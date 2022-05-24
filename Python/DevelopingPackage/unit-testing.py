# unit testing

'''
Running tests with pytest from the terminal
pytest looks inside the test directory
  it looks for modules like : test_modulename.py
  it looks for functions like : test_functionname()
  it runs these functions and shows output
'''

# unit testing on each environment
'''
As there are different versions of Python this can impact how the tests will be performed. Maintaining a 
record of all version testing can become combersome. Python has a method to handle this using tox() in the 
terminal. To incorporate the appropriate testing we have to inclued a new configuration file.
'''
# stored within the top level of the my package directory
configuration file : tox.ini
creating the tox.ini file
code 
[tox]
envlist = py27, py35, py36, py37
[testenv]
deps = pytest
commands = 
pytest
echo "run more commands"
# have to ensure that each version of python that we want tested is installed within the computer we are using
