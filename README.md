# Sensor-Driven-Music-Player
The app utilizes accelerometer from the mobile device to control the speed of a sound loop. Moving the device up along Y-Axis increase the temp and moving down decreases the temp

# How to run
Since it depends on the Sensors data , the app will work best on the mobile devices.

## Android

### Running the debug build directly

For convenience a debug build is already created for android devices. 
1. Download the debug build from `https://drive.google.com/drive/folders/1v7Eovuq9RCSMsHzsVMPTuQ2Iyn58jVyu?usp=sharing` into your android device

2. Run the `app-debug.apk` from your android device and run.

### Running the debug build

1. Connect the device via the usb-cable and make sure to turn on the `usb debugging` via the developer option in the android phone.
2. Once your device is connected and found via `flutter devices` or `adb devices`. Run flutter command.
```
flutter install
```
This will ask you to select the android phone. Choose it and wait until the debug apk is build


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

