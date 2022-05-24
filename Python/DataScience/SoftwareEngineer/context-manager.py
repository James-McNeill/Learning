# Writing context manager

'''
Can use a context manager to setup a process. Perform some tasks. Then clear the process away as if it never happened
'''

# Yielding a value or None
@contextlib.contextmanager
def database(url):
  # set up database connection
  db = postgres.connect(url)
  
  yield db
  
  # tear down database connection
  db.disconnect()

url = ''
with database(url) as my_db:
  list = my_db.execute(
    'SELECT * FROM table'
  )

@contextlib.contextmanager
def in_dir(path):
  # save current working directory
  old_dir = os.getcwd()
  
  # switch to new working directory
  os.chdir(path)
  
  yield
  
  # change back to previous
  # working directory
  os.chdir(old_dir)

with in_dir(''):
  project_files = os.listdir()
