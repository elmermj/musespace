import 'package:musespace/data/models/song_model.dart';

class RemoteSongDataSource {
  Future<List<SongModel>> getRemoteSongs(){
    return Future.delayed(const Duration(seconds: 2), () {
      return [
        SongModel(
          id: "1",
          songTitle: "song1",
          artist: "artist1",
          albumName: "album1",
          songUrl: "songUrl1",
        )
      ];
    });
  }
}