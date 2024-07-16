class SongModel {
  String? id;
  String? songTitle;
  String? artist;
  String? albumName;
  String? songUrl;

  SongModel({
    this.id,
    this.songTitle,
    this.artist,
    this.albumName,
    this.songUrl,
  });

  factory SongModel.fromJson(Map<String, dynamic> json) {
    return SongModel(
      id: json['id'],
      songTitle: json['songTitle'],
      artist: json['artist'],
      albumName: json['albumName'],
      songUrl: json['songUrl'],
    );
  }

  //to map
  
}