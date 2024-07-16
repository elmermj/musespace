import 'dart:io';

import 'package:musespace/data/models/song_model.dart';

class LocalSongDataSource {
  Future<List<SongModel>> getLocalSongs(Directory dir) async {
    final musicFiles = <SongModel>[];
    await for (var entity in dir.list(recursive: true, followLinks: false)) {
      if (entity.runtimeType != File) continue;
      if (entity.path.endsWith('.mp3')) {
        final fileName = entity.uri.pathSegments.last;
        musicFiles.add(SongModel(
          id: entity.path,
          songTitle: fileName,
          artist: 'Unknown Artist',
          songUrl: entity.path,
        ));
      }
    }
    return musicFiles;
  }
}