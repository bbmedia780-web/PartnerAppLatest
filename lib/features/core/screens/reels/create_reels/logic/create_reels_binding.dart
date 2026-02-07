import 'package:get/get.dart';
import 'create_reels_controller.dart';

class CreateReelsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreateReelsController());
  }
}

