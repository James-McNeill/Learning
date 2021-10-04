# Two datasets are being reviewed. First one is a classification challenge and the second is a regression challenge

# 1. Classification
# Dealing with the heartbeat data that has a large number of samples per second
import librosa as lr
from glob import glob # used to help work with a large number of files stored in a directory

# List all the wav files in the folder
audio_files = glob(data_dir + '/*.wav')

# Read in the first audio file, create the time array
audio, sfreq = lr.load(audio_files[0])
time = np.arange(0, len(audio)) / sfreq

# Plot audio over time
fig, ax = plt.subplots()
ax.plot(x=time, y=audio)
ax.set(xlabel='Time (s)', ylabel='Sound Amplitude')
plt.show()

# 2. Regression
# Read in the data
data = pd.read_csv('prices.csv', index_col=0)

# Convert the index of the DataFrame to datetime
data.index = pd.to_datetime(data.index)
print(data.head())

# Loop through each column, plot its values over time
fig, ax = plt.subplots()
for column in data.columns:
    data[column].plot(ax=ax, label=column)
ax.legend()
plt.show()
