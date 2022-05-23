# Pendulum
'''
Provides a powerful way to convert strings to pendulum datetime objects via the .parse() method. Just pass it a date string 
and it will attempt to convert into a valid pendulum datetime. By default, .parse() can process dates in ISO 8601 format. To 
allow it to parse other date formats, pass strict = False.

It also has a wonderful alternative to timedelta. When calculating the difference between two dates by subtraction, pendulum 
provides methods such as .in_days() to output the difference in a chosen metric. These are just the beginning of what 
pendulum can do for you.
'''
# Iterate over date_ranges
for start_date, end_date in date_ranges:

    # Convert the start_date string to a pendulum date: start_dt 
    start_dt = pendulum.parse(start_date, strict=False)
    
    # Convert the end_date string to a pendulum date: end_dt 
    end_dt = pendulum.parse(end_date, strict=False)
    
    # Print the End and Start Date
    print(end_dt, start_dt)
    
    # Calculate the difference between end_dt and start_dt: diff_period
    diff_period = end_dt - start_dt
    
    # Print the difference in days
    print(diff_period.in_days())
