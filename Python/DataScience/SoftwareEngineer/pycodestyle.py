# pycodestyle

'''
pycodestyle can be run from the command line to check a file for PEP 8 compliance. Sometimes it's useful to run this kind of check from a Python script.
'''
# Import needed package
import pycodestyle

# Create a StyleGuide instance
style_checker = pycodestyle.StyleGuide()

# Run PEP 8 check on multiple files
result = style_checker.check_files(['nay_pep8.py', 'yay_pep8.py'])

# Print result of PEP 8 style check
print(result.messages)
# shows if there are anyways that the code can be improved from a readability standpoint
