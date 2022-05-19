# Timeout decorator
def timeout(n_seconds):
  def decorator(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
      # Set an alarm for n seconds
      signal.alarm(n_seconds)
      try:
        # Call the decorated func
        return func(*args, **kwargs)
      finally:
        # Cancel alarm
        signal.alarm(0)
      return wrapper
    return decorator

# Example of the decorator being used
@timeout(5)
def foo():
  time.sleep(10)
  print('foo!')
@timeout(20)
def foo():
  time.sleep(10)
  print('bar!')
foo()
