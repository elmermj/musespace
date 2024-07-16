import 'package:dartz/dartz.dart';
import 'package:musespace/data/models/song_model.dart';
import 'package:musespace/data/source/local/local_song_data_source.dart';
import 'package:musespace/data/source/remote/remote_song_data_source.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class SongRepository {
  Future<Either<Exception, List<SongModel>>>getAllSongs();
}

class SongRepositoryImpl extends SongRepository {
  final RemoteSongDataSource _remoteDataSource;
  final LocalSongDataSource _localDataSource;

  SongRepositoryImpl({required RemoteSongDataSource remoteDataSource, required LocalSongDataSource localDataSource}) : _remoteDataSource = remoteDataSource, _localDataSource = localDataSource;

  @override
  Future<Either<Exception, List<SongModel>>> getAllSongs() async {
    try {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        return Left(Exception('Storage permission not granted'));
      }
      final dir = await getExternalStorageDirectory();
      if (dir == null) {
        return Left(Exception('Failed to access external storage'));
      }
      final musicFiles = await _localDataSource.getLocalSongs(dir);      
      return Right(musicFiles);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}