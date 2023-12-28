import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthflex/api/api.dart';
import 'package:healthflex/models/models.dart';

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

  String error = "";
  Future<void> fetchSongs() async {
    try {
      var songsList = await Api.fetchSongList();
      songs = songsList.results;
    } catch (e) {
      error = e.toString();

      log(error);
    } finally {
      log(songsList.toString());
      notifyListeners();
    }
  }

  Future<void> fetchSong(int id) async {
    try {
      audio = await Api.fetchSongById(id);
    } catch (e) {
      error = e.toString();

      log(error);
    } finally {
      notifyListeners();
    }
  }
}
