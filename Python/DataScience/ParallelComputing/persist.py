# persist

'''
Keeping the dataframe in memory can help to reduce computation time if a number of calculations are required for the same dataframe.
'''
# Print time in milliseconds to compute percent_delayed on weather_delays
t_start = time.time()
print(percent_delayed(weather_delays).compute())
t_end = time.time()
print((t_end-t_start)*1000)

# Call weather_delays.persist(): persisted_weather_delays
persisted_weather_delays = weather_delays.persist()

# Print time in milliseconds to compute percent_delayed on persisted_weather_delays
t_start = time.time()
print(percent_delayed(persisted_weather_delays).compute())
t_end = time.time()
print((t_end-t_start)*1000)
