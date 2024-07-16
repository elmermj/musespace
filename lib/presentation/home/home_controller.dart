import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musespace/data/models/song_model.dart';
import 'package:musespace/domain/repositories/song_repository.dart';
import 'package:musespace/service/player_service.dart';
import 'package:musespace/service/state_service.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin{
  final SongRepository songRepository;
  HomeController({
    required this.songRepository
  });
  
  StateService state = Get.find<StateService>();

  RxList<SongModel> songs = <SongModel>[].obs;  

  late AnimationController animationController;
  late Animation<double> menuOpacityAnimation;

  @override
  Future<void> onInit() async {
    super.onInit();
    state.isLoading.value = true;
    getSongs();
    state.isLoading.value = false;
  }

  initAnimationControllers() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 200,
      ),
    );
    menuOpacityAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeIn,
    );
  }

  getSongs() {
    songs.addAll(Get.find<PlayerService>().songs);
  }
}