# NER with polyglot library

# Works across 130 languages. Can be used to convert from one language vector to another.
# The algorithm can even understand which language it is reviewing so this doesn't have to
# be explictly specified.

# Import module
from polyglot.text import Text

# Create a new text object using Polyglot's Text class: txt
txt = Text(article)

# Print each of the entities found
for ent in txt.entities:
    print(ent)
    
# Print the type of ent
print(type(ent))
