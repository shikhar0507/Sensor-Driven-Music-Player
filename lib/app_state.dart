import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthflex/api/api.dart';
import 'package:healthflex/models/models.dart';

/// AppState uses the ChangeNotifier to keep a consistent app state across screens. 
/// Here songsList and audio are used as state properties to be later used in the widgets
class AppState extends ChangeNotifier {
  Map<String, dynamic> songsList = {};
  List<Song> songs = [];
  Audio audio = const Audio(
    description: "",
    preview: "",
    bitrate: 0,
    image: "",
    duration: 0,
  );

  // For error cases 
  String error = "";
  // fetchSongs() - Calls the required API method and store the results in the state variables
  // and setting the error value
  Future<void> fetchSongs() async {
    try {
      var songsList = await Api.fetchSongList();
      songs = songsList.results;
      error = "";
    } catch (e) {
      log(e.toString());
      error = "Failed to fetch the song list";
    } finally {
      notifyListeners();
    }
  }

  // fetchSong() - Calls the required API method and store the results in the state variables,
  // and setting the error value
  Future<void> fetchSong(int id) async {
    try {
      audio = await Api.fetchSongById(id);
      error = "";
    } catch (e) {
      error = "Failed to fetch the song details";
      log(e.toString());
    } finally {
      notifyListeners();
    }
  }
}
