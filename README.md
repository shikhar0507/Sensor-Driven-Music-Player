# Sensor-Driven-Music-Player
The app utilizes accelerometer from the mobile device to control the speed of a sound loop. Moving the device up along Y-Axis increase the temp and moving down decreases the temp

# Implementation

![Implementation](https://github.com/shikhar0507/Sensor-Driven-Music-Player/blob/main/image.png?raw=true)



# Challenges
1. Accelerometer X-axis is not a good measure for mapping temp to the directional changes. The movement is more easily identified when Y-Axis is used. Mapping X-axis to "right" & "left" gave unexpected values  almost all the time.

2. Mapping tempo to the Sensor data. The algorithm normalizes the value in the positive range and then scale it back

# Improvements
1. Current Implementation downloads the audio loop everytime before it starts to play the loop. `AudioCache` or Flutter Cache can be used to first fetch the song from cache (if-present) else download and play. This reduces the first play wait.

2. A better normalization can be implemented on mapping the accelerometer data to the tempo value. Current one work but more windows can be created.

3. A search bar for choosing different sounds

