# Working with distinct() and sets

# A. Distinct values
# 1. Comparing sets
# Countries recorded as countries of death but not as countries of birth. Distinct method will show the unique values in the document
countries = set(db.laureates.distinct("diedCountry")) - set(db.laureates.distinct("bornCountry"))
print(countries)
