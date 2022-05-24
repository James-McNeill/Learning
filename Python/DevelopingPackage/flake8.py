# Static code checker: flake8

'''
The code can be run through the terminal to check through a module and understand if any improvements can be made to help make the code look more stylish.
To switch off a line of code to review add (#noqa). Can also pass a command for the error codes. Can have a flake8 setup.cfg file
'''
flake8 user_module.py
config file
[flake8]

ignore = E302
exclude = setup.py
per-file-ignores = example_package/example_package.py E222
