# Performing readability test analysis

# 1. Reviewing one article for difficulty.
# Import Textatistic
from textatistic import Textatistic

# Compute the readability scores 
readability_scores = Textatistic(sisyphus_essay).scores

# Print the flesch reading ease score - the higher the value the easier the difficulty
flesch = readability_scores['flesch_score']
print("The Flesch Reading Ease is %.2f" % (flesch))

# Import Textatistic
from textatistic import Textatistic

# List of excerpts
excerpts = [forbes, harvard_law, r_digest, time_kids]

# Loop through excerpts and compute gunning fog index
gunning_fog_scores = []
for excerpt in excerpts:
  readability_scores = Textatistic(excerpt).scores
  gunning_fog = readability_scores['gunningfog_score']
  gunning_fog_scores.append(gunning_fog)

# Print the gunning fog indices - the lower the value the easier the difficulty
print(gunning_fog_scores)
