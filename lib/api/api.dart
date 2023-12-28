import 'dart:convert';
import 'package:healthflex/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Api - This class handled the http.get method for fetching the songs as well as audio from the 
/// freesound.org. Two methods are avaialbe 
/// 1. fetchSongList() - Fetch the songs
/// 2. fetchSongById(int id) - Fetch a paricular song details along with the audio by id 
class Api {
  // fetchSongList - Fetches the songs list from the API and parse the result into
  // SongList class 
  static Future<SongsList> fetchSongList() async {
    var token = dotenv.env["API_TOKEN"] as String;

    final response = await http.get(
      Uri.parse(
          "https://freesound.org/apiv2/search/text/?query=beat&token=$token"),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to fetch sounds");
    } else {
      return SongsList.parseJSON(
          jsonDecode(response.body) as Map<String, dynamic>);
    }
  }

  // fetchSongList - Fetches and audio sound from the API and parse the result into
  // Audio Class
  static Future<Audio> fetchSongById(int id) async {
    var token = dotenv.env["API_TOKEN"] as String;

    final response = await http.get(
      Uri.parse("https://freesound.org/apiv2/sounds/$id/?token=$token"),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to fetch sound");
    } else {
      return Audio.parseJSON(jsonDecode(response.body) as Map<String, dynamic>);
    }
  }
}
