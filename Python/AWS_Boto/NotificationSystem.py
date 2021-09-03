# Building a notification system that will work on a schedule to complete the task requested and monitor alerts
# Build the initial dictionary for each of the department ARN topics
dept_arns = {} 

for dept in departments:
  # For each deparment, create a critical topic
  critical = sns.create_topic(Name="{}_critical".format(dept))
  # For each department, create an extreme topic
  extreme = sns.create_topic(Name="{}_extreme".format(dept))
  # Place the created TopicARNs into a dictionary 
  dept_arns['{}_critical'.format(dept)] = critical['TopicArn']
  dept_arns['{}_extreme'.format(dept)] = extreme['TopicArn']

# Print the filled dictionary.
print(dept_arns)

# Create the subscriptions for each of the groups
for index, user_row in contacts.iterrows():
  # Get topic names for the users's dept
  critical_tname = '{}_critical'.format(user_row['Department'])
  extreme_tname = '{}_extreme'.format(user_row['Department'])
  
  # Get or create the TopicArns for a user's department.
  critical_arn = sns.create_topic(Name=critical_tname)['TopicArn']
  extreme_arn = sns.create_topic(Name=extreme_tname)['TopicArn']
  
  # Subscribe each users email to the critical Topic
  sns.subscribe(TopicArn = critical_arn, 
                Protocol='email', Endpoint=user_row['Email'])
  # Subscribe each users phone number for the extreme Topic
  sns.subscribe(TopicArn = extreme_arn, 
                Protocol='sms', Endpoint=str(user_row['Phone']))
  
# Send out the alert messages based on conditional statements
if vcounts['water'] > 100:
  # If over 100 water violations, publish to water_critical
  sns.publish(
    TopicArn = dept_arns['water_critical'],
    Message = "{} water issues".format(vcounts['water']),
    Subject = "Help fix water violations NOW!")

if vcounts['water'] > 300:
  # If over 300 violations, publish to water_extreme
  sns.publish(
    TopicArn = dept_arns['water_extreme'],
    Message = "{} violations! RUN!".format(vcounts['water']),
    Subject = "THIS IS BAD.  WE ARE FLOODING!")
