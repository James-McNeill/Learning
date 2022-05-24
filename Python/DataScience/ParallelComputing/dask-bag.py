# dask bag
'''
Working with unstructured data can be a bit more challenging. These methods aim to bring the unstructured data together.
'''
nested_containers = [[0, 1, 2, 3],{},                     
                     [6.5, 3.14], 'Python',                     
                     {'version':3}, '' ]

import dask.bag as db

the_bag = db.from_sequence(nested_containers)
the_bag.count()
# 6

the_bag.any(), the_bag.all()
# True, False

# Glob expressions
df = dd.read_csv('taxi/*.csv', assume_missing=True)
txt_files = glob.glob('*.txt')
# Example : split speeches into words and compute average length
# Call .str.split(' ') from speeches and assign it to by_word
by_word = speeches.str.split(' ')

# Map the len function over by_word and compute its mean
n_words = by_word.map(len)
avg_words = n_words.mean()

# Print the type of avg_words and value of avg_words.compute()
print(type(avg_words))
print(avg_words.compute())

# Convert speeches to lower case: lower
lower = speeches.str.lower()

# Filter lower for the presence of 'health care': health
health = lower.filter(lambda s:'health care' in s)

# Count the number of entries : n_health
n_health = health.count()

# Compute and print the value of n_health
print(n_health.compute())
# Number of speeches that had contained the string "health care"

# Filter the bills: overridden
overridden = bills_dicts.filter(veto_override)

# Print the number of bills retained
print(overridden.count().compute())

# Get the value of the 'title' key
titles = overridden.pluck('title')

# Compute and print the titles
print(titles.compute())
