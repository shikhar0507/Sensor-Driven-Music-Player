import 'dart:convert';
import 'package:healthflex/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Api {

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