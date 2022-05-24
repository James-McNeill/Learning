# tmpdir

'''
The built-in tmpdir fixture is very useful when dealing with files in setup and teardown. tmpdir 
combines seamlessly with user defined fixture via fixture chaining.
'''
import pytest

@pytest.fixture
# Add the correct argument so that this fixture can chain with the tmpdir fixture
def empty_file(tmpdir):
    # Use the appropriate method to create an empty file in the temporary directory
    file_path = tmpdir.join("empty.txt")
    open(file_path, "w").close()
    yield file_path
