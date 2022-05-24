# Pytest and Cat

'''
Unit testing helps to ensure that the code being used produces the correct output. In order for the testing to be 
run efficiently you need to add the prefix "test_" and then pytest is able to review the module py file.
'''
!pytest
!cat

# runs each of the assert tests and highlights pass / fails
!pytest test_module.py
# outputs the tests that are being run on the module which can help to show the key features of the module and allow users to understand the code better
!cat test_module.py
