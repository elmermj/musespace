import 'package:get/get.dart';
import 'package:musespace/data/models/song_model.dart';
import 'package:musespace/domain/repositories/song_repository.dart';
import 'package:musespace/service/state_service.dart';

class PlayerService extends GetxService {
  final SongRepository songRepository;
  PlayerService({
    required this.songRepository
  });
  StateService state = Get.find<StateService>();

  RxList<SongModel> songs = <SongModel>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await getSongs();
  }

  getSongs() async {
    state.isLoading.value = true;
    try {
      final result = await songRepository.getAllSongs();
      result.fold(
        (error){
          state.isLoading.value = false;
          if(Get.isSnackbarOpen) Get.back();
          Get.snackbar(
            "Error", "$error"
          );
        }, 
        (songs){
          songs.addAll(songs);
          state.isLoading.value = false;
        }
      );
    } catch (e) {
      state.isLoading.value = false;
      if(Get.isSnackbarOpen) Get.back();
      Get.snackbar(
        "Error", "$e"
      );
    }
  }
}