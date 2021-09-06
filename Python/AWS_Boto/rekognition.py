# Working with images to detect objects that are seen within the images. A confidence
# level will be return when detecting the labels

# 1. Reviewing two images to check for the presence of a cat
# Use Rekognition client to detect labels
image1_response = rekog.detect_labels(
    # Specify the image as an S3Object; Return one label
    Image=image1, MaxLabels=1)

# Print the labels
print(image1_response['Labels'])

# Use Rekognition client to detect labels
image2_response = rekog.detect_labels(Image=image2, MaxLabels=1)

# Print the labels
print(image2_response['Labels'])

# 2. Building a detector to count for the presence of multiple cats
# NOTES: rekognition client was setup, .detect_labels() was called and output stored in response variable
# Create an empty counter variable
cats_count = 0
# Iterate over the labels in the response
for label in response['Labels']:
    # Find the cat label, look over the detected instances
    if label['Name'] == 'Cat':
        for instance in label['Instances']:
            # Only count instances with confidence > 85
            if (instance['Confidence'] > 85):
                cats_count += 1
# Print count of cats
print(cats_count)

# 3. Detect text within an image
# NOTES: rekognition client was setup, .detect_text() was called and output stored in response variable
# Create empty list of words - will separate out each word within the image
words = []
# Iterate over the TextDetections in the response dictionary
for text_detection in response['TextDetections']:
  	# If TextDetection type is WORD, append it to words list
    if text_detection['Type'] == 'WORD':
        # Append the detected text
        words.append(text_detection['DetectedText'])
# Print out the words list
print(words)

# Create empty list of lines - will separate out each line within the image
lines = []
# Iterate over the TextDetections in the response dictionary
for text_detection in response['TextDetections']:
  	# If TextDetection type is Line, append it to lines list
    if text_detection['Type'] == 'LINE':
        # Append the detected text
        lines.append(text_detection['DetectedText'])
# Print out the words list
print(lines)
