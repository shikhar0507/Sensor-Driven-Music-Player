/// SongsList - Parse the Api response into SongsList to extract results and the count  
class SongsList {
  final int count;
  final List<Song> results;

  const SongsList({required this.count, required this.results});

  factory SongsList.parseJSON(Map<String, dynamic> json) {
    if (json.containsKey("count") && json.containsKey("results")) {
      final count = json["count"] as int;
      final results = (json["results"] as List<dynamic>)
          .map((result) => Song.parseJSON(result as Map<String, dynamic>))
          .toList();

      return SongsList(count: count, results: results);
    }

    throw const FormatException("Failed to parse SongsList");
  }
}

/// SongsList - Parse the SongsList result into Song to extract song details like id, username and tags 
class Song {
  final int id;
  final String name;
  final String username;
  final List<String> tags;

  const Song({
    required this.id,
    required this.name,
    required this.username,
    required this.tags,
  });

  factory Song.parseJSON(Map<String, dynamic> json) {
    return Song(
      id: json["id"] as int,
      name: json["name"] as String,
      username: json["username"] as String,
      tags: (json["tags"] as List<dynamic>).cast<String>(),
    );
  }
}

/// Audio - Parse the fetchSongById API Response into Audio to get bitrate and sound file
class Audio {
  final String description;
  final String preview;
  final int bitrate;
  final String image;
  final double duration;

  const Audio({
    required this.description,
    required this.preview,
    required this.bitrate,
    required this.image,
    required this.duration,
  });

  factory Audio.parseJSON(Map<String, dynamic> json) {
    return Audio(
      description: json["description"],
      preview: json["previews"]["preview-hq-mp3"],
      bitrate: json["bitrate"],
      image: json["images"]["waveform_m"],
      duration: json["duration"],
    );
  }
}
