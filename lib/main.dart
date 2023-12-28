import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:healthflex/app_state.dart';
import 'package:flutter/material.dart';
import 'package:healthflex/models/models.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const HealthFlex());
}

class HealthFlex extends StatelessWidget {
  const HealthFlex({Key? key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        title: 'Healthflex',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        ),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppState>(context, listen: false).fetchSongs();
    });
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Heading in the body
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Healthflex',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          appState.songs.isEmpty
              ? SizedBox(
                  height: MediaQuery.of(context).size.height / 1.3,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              :
              // Use an Expanded widget to allow the ListView to take up all available space
              Expanded(
                  child: ListView.builder(
                    itemCount: appState.songs.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(appState.songs[index].name),
                        subtitle: Text(appState.songs[index].username),
                        onTap: () {
                          appState.audio = const Audio(
                            description: "",
                            preview: "",
                            bitrate: 0,
                            image: "",
                            duration: 0,
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SongPage(song: appState.songs[index]),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}

class SongPage extends StatefulWidget {
  final Song song;
  const SongPage({Key? key, required this.song});

  @override
  _SongPage createState() => _SongPage();
}

class _SongPage extends State<SongPage> {
  bool isPlay = false;
  AudioPlayer? audioPlayer;
  StreamSubscription<AccelerometerEvent>? accelerometerSubscription;
  double accelX = 0;
  double accelY = 0;
  double accelZ = 0;
  bool isStreamFirstTime = true;
  String errorAudioPlay = "";
  @override
  void initState() {
    super.initState();

    audioPlayer ??= AudioPlayer();

    if (Platform.isAndroid || Platform.isIOS) {
      accelerometerSubscription = accelerometerEventStream().listen(
        (AccelerometerEvent event) {
          if (mounted) {
            setState(() {
              accelX = event.x;
              accelY = event.y;
              accelZ = event.z;
            });
            if (isPlay) {
              _setupAudioTempo();
            }
          }
        },
        onError: (error) {
          Fluttertoast.showToast(
              msg: "Failed to fetch the sensors data",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER);
          log(error.toString());
        },
        cancelOnError: true,
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppState>(context, listen: false).fetchSong(widget.song.id);
    });
  }

  void _initAudio(AppState appState) async {
    audioPlayer!.onPlayerComplete.listen((event) async {
      _setupAudioState(appState);
    });
  }

  void _setupAudioState(AppState appState) async {
    if (audioPlayer != null && appState.audio.preview.isNotEmpty) {
      try {
        await audioPlayer?.play(UrlSource(appState.audio.preview));
        audioPlayer!.setVolume(1);
      } catch (e) {
        setState(() {
          errorAudioPlay = "Failed to play the audio preview. Try another song";
        });
      }
    }
  }

  void _setupAudioTempo() async {
    double newTempo = accelY;

    // Min-Max range as specifed in the docs
    newTempo = mapDataToSmoothRange(newTempo);
    newTempo = newTempo.clamp(0.5, 2);
    log("$newTempo");
    if (audioPlayer != null && mounted) {
      await audioPlayer?.setPlaybackRate(newTempo);
    }
  }

  double mapDataToSmoothRange(double inputData) {
    double normalizedData = (inputData + 10) / 20;

    double smoothValue = normalizedData * normalizedData;

    double mappedValue = smoothValue * 1.5 + 0.5;

    return mappedValue;
  }

  @override
  void dispose() {
    audioPlayer?.dispose();
    audioPlayer?.onPlayerComplete.listen((event) {}).cancel();
    accelerometerSubscription?.cancel();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.song.name),
        actions: [
          BackButton(
            onPressed: () async => {await audioPlayer!.stop()},
          )
        ],
      ),
      body: appState.audio.preview.isEmpty
          ? SizedBox(
              height: MediaQuery.of(context).size.height / 1.3,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Center(
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    ListTile(
                      title: Text(widget.song.name),
                      subtitle: Text(
                          "${widget.song.username} : ${appState.audio.duration}"),
                    ),
                    if (appState.audio.image.isNotEmpty)
                      Image.network(appState.audio.image),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        appState.audio.description,
                        style: TextStyle(color: Colors.black.withOpacity(0.6)),
                      ),
                    ),
                    if(Platform.isAndroid || Platform.isIOS)
                      Text("X: $accelX"),
                      Text("Y: $accelY"),
                      Text("Z: $accelZ"),
                    errorAudioPlay.isNotEmpty
                        ? Text(errorAudioPlay)
                        : ButtonBar(
                            alignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    isPlay = !isPlay;
                                  });
                                  log("playing ${widget.song.id}");
                                  if (isPlay && appState.audio.preview != "") {
                                    if (isStreamFirstTime) {
                                      Fluttertoast.showToast(
                                          msg: "Wait, fetching the stream",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER);
                                    }
                                    isStreamFirstTime = false;

                                    _initAudio(appState);
                                    _setupAudioState(appState);
                                  } else {
                                    audioPlayer?.pause();
                                  }
                                },
                                child: Text(isPlay ? 'Pause' : 'Play'),
                              ),
                            ],
                          )
                  ],
                ),
              ),
            ),
    );
  }
}
