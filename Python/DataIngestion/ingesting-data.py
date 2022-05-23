# Ingesting data

'''
Working with data lakes to create various pipelines
You’re given a dataset of pricing details of diapers from several stores. After some inspection, you understand that the products 
have an identical schema, regardless of the store.

Since your company is already invested in Stitch, the mother company of Singer, you’ll be writing a custom Singer “tap” to export 
the different products in a standardized way. To do so, you will need to associate a schema with the actual data.
'''
# Import json
import json

database_address = {
  "host": "10.0.0.5",
  "port": 8456
}

# Open the configuration file in writable mode
with open("database_config.json", "w") as fh:
  # Serialize the object in this file handle
  json.dump(obj=database_address, fp=fh) 
# API that is used to create the schema
import singer
# Complete the JSON schema
schema = {'properties': {
    'brand': {'type': 'string'},
    'model': {'type': 'string'},
    'price': {'type': 'number'},
    'currency': {'type': 'string'},
    'quantity': {'type': 'number', 'minimum': 1},  
    'date': {'type': 'string', 'format': 'date'},
    'countrycode': {'type': 'string', 'pattern': "^[A-Z]{2}$"}, 
    'store_name': {'type': 'string'}}}

# Write the schema
singer.write_schema(stream_name="products", schema=schema, key_properties=[])
