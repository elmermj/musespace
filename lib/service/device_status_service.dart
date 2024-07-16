import 'package:get/get.dart';

class DeviceStatusService extends GetxService{
  RxBool isLogin = false.obs;
  RxBool permissionsGranted = false.obs;

  bool isAdmin = false;

  @override
  Future<void> onInit() async {
    super.onInit();
  }
}