# Example of how the use the AWS Rekognition tools to automate rekognition tasks
# 1. Review the information provided in the responses. Convert to English. Store sentiment
for index, row in scooter_requests.iterrows():
  	# For every DataFrame row
    desc = scooter_requests.loc[index, 'public_description']
    if desc != '':
      	# Detect the dominant language
        resp = comprehend.detect_dominant_language(Text=desc)
        lang_code = resp['Languages'][0]['LanguageCode']
        scooter_requests.loc[index, 'lang'] = lang_code
        # Use the detected language to determine sentiment
        scooter_requests.loc[index, 'sentiment'] = comprehend.detect_sentiment(
          Text=desc, 
          LanguageCode=lang_code)['Sentiment']
# Perform a count of sentiment by group.
counts = scooter_requests.groupby(['sentiment', 'lang']).count()
counts.head()
