import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musespace/presentation/home/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  HomeScreen({super.key});

  @override
  final controller = Get.put(HomeController(songRepository: Get.find()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: controller.songs.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(controller.songs[index].songTitle!),
            subtitle: Text(controller.songs[index].artist!),
          );
        },
      ),
      bottomNavigationBar: SizedBox(
        height: kBottomNavigationBarHeight,
        width: Get.width,
        child: Center(
          child: Obx(
            () {
              double textSize = controller.state.isLoading.value ? 0: Get.textTheme.bodySmall!.fontSize!;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: controller.state.isLoading.value? Colors.transparent :Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.only(bottom: 20),
                width: Get.width * 0.9,
                height: 40,
                child: controller.state.isLoading.value
              ? FadeTransition(opacity: controller.menuOpacityAnimation, child: const Center(child: CircularProgressIndicator(color: Colors.black, backgroundColor: Colors.white,)))
              : FadeTransition(
                  opacity: controller.menuOpacityAnimation,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.0, end: textSize),
                    duration: const Duration(milliseconds: 200),
                    builder: (context, size, child) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {},
                              child: Center(
                                child: Text(
                                  'History',
                                  style: TextStyle(color: Colors.white, fontSize: size),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {},
                              child: Center(
                                child: Text(
                                  'Settings',
                                  style: TextStyle(color: Colors.white, fontSize: size),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {},
                              child: Center(
                                child: Text(
                                  'About',
                                  style: TextStyle(color: Colors.white, fontSize: size),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {},
                              child: Center(
                                child: Text(
                                  'Exit',
                                  style: TextStyle(color: Colors.white, fontSize: size),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                )                
              );
            },
          )
        )
      ),
    );
  }
}