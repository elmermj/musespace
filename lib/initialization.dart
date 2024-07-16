import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musespace/data/source/local/local_song_data_source.dart';
import 'package:musespace/data/source/remote/remote_song_data_source.dart';
import 'package:musespace/domain/repositories/song_repository.dart';
import 'package:musespace/service/device_status_service.dart';
import 'package:musespace/service/player_service.dart';
import 'package:musespace/service/state_service.dart';
import 'package:musespace/utils/log.dart';
import 'package:permission_handler/permission_handler.dart';

class Initialization {
  static run() async {
    await Hive.initFlutter();

    Get.put<LocalSongDataSource>(LocalSongDataSource());
    Get.put<RemoteSongDataSource>(RemoteSongDataSource());

    Get.put<SongRepository>(
      SongRepositoryImpl(
        remoteDataSource: Get.find(),
        localDataSource: Get.find(),
      ),
    );

    Get.put<StateService>(StateService());
    Get.put<PlayerService>(PlayerService(
      songRepository: Get.find()
    ));

    Get.put<DeviceStatusService>(DeviceStatusService());

    await requestPermissions(Get.find<DeviceStatusService>());
  }

  static requestPermissions(DeviceStatusService deviceStatusService) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if(Platform.isAndroid && deviceStatusService.permissionsGranted.value==false){
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      int apiLevel = androidInfo.version.sdkInt;
      Log.yellow("API LEVEL ::: $apiLevel");
      if(apiLevel >= 33){
        PermissionStatus storageStatus = await Permission.manageExternalStorage.request();
        PermissionStatus photosStatus = await Permission.photos.request();
        PermissionStatus cameraStatus = await Permission.camera.request();
        PermissionStatus videoStatus = await Permission.videos.request();
        PermissionStatus audioStatus = await Permission.audio.request();
        PermissionStatus mediaStatus = await Permission.mediaLibrary.request();
        PermissionStatus microphoneStatus = await Permission.microphone.request();

        if(
          storageStatus.isDenied &&
          photosStatus.isDenied &&
          cameraStatus.isDenied &&
          videoStatus.isDenied &&
          audioStatus.isDenied &&
          mediaStatus.isDenied &&
          microphoneStatus.isDenied
        ){
          deviceStatusService.permissionsGranted.value = false;
        }else {
          deviceStatusService.permissionsGranted.value = true;
        }
        Log.yellow("STORAGE STATUS ::: $storageStatus");
        Log.yellow("PHOTOS STATUS ::: $photosStatus"); 
        Log.yellow("CAMERA STATUS ::: $cameraStatus");
        Log.yellow("VIDEO STATUS ::: $videoStatus");
        Log.yellow("AUDIO STATUS ::: $audioStatus");
        Log.yellow("MEDIA STATUS ::: $mediaStatus");
        Log.yellow("MICROPHONE STATUS ::: $microphoneStatus");
        Log.yellow("Permission STATUS ::: ${deviceStatusService.permissionsGranted.value}");

      } else {
        PermissionStatus externalStorageStatus = await Permission.manageExternalStorage.request();
        PermissionStatus storageStatus = await Permission.storage.request();
        PermissionStatus microphoneStatus = await Permission.microphone.request();
        PermissionStatus cameraStatus = await Permission.camera.request();

        if(
          externalStorageStatus.isDenied && 
          storageStatus.isDenied &&
          microphoneStatus.isDenied &&
          cameraStatus.isDenied
        ){
          deviceStatusService.permissionsGranted.value = false;
        }else {
          deviceStatusService.permissionsGranted.value = true;
        }
      }
    }
  }
}