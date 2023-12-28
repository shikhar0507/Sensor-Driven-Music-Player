# Sensor-Driven-Music-Player
The app utilizes accelerometer from the mobile device to control the speed of a sound loop. Moving the device up along Y-Axis increase the temp and moving down decreases the temp

# Implementation

![Implementation](https://github.com/shikhar0507/Sensor-Driven-Music-Player/blob/main/image.png?raw=true)

## Code Flow
1. The `HomePage` Class calls the `fetchSongs()` method to fetch the list of songs via `freesound.org/apiv2/search/text/?query=beat`. A view is build using `ListViewBuilder`. Upon clicking any listItem a new View is created `SongPage`

2. The `SongPage` Class takes care of showing the audio image, description, duration and other metadata. Upon initializing the Class , the accelerometer data is read via the `accelerometerEventStream`. Y-Axis values are used to map the device movement to the tempo.

After first `Play` press the audioPlayer starts to call the `_setupAudioTempo` function which takes care of the normalization of the tempo. As device keeps moving `_setupAudioTempo` keeps getting called

# Challenges
1. Accelerometer X-axis is not a good measure for mapping temp to the directional changes. The movement is more easily identified when Y-Axis is used. Mapping X-axis to "right" & "left" gave unexpected values  almost all the time.

2. Mapping tempo to the Sensor data. The algorithm normalizes the value in the positive range and then scale it back

# Improvements
1. Current Implementation downloads the audio loop everytime before it starts to play the loop. `AudioCache` or Flutter Cache can be used to first fetch the song from cache (if-present) else download and play. This reduces the first play wait.

2. A better normalization can be implemented on mapping the accelerometer data to the tempo value. Current one work but more windows can be created.

3. A search bar for choosing different sounds

