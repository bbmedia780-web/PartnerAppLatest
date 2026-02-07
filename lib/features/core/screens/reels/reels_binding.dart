import 'package:get/get.dart';
import 'reels_controller.dart';

class ReelsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReelsController());
  }
}

