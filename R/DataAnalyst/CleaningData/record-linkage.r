# Record linkage techniques
# Allows for the combining of datasets that have similar keys which are not completely exact

# A. Comparing strings
# 1. Small distance, small difference
# The stringdist package has been loaded for you.
# Each method performs a different combination of possible actions to compare differences in strings.
# Common actions include; insertion, deletion, subsitution and transposition
stringdist("las angelos", "los angeles", method = "dl")
stringdist("las angelos", "los angeles", method = "lcs")
stringdist("las angelos", "los angeles", method = "jaccard")

