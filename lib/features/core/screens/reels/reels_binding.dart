import 'package:get/get.dart';
import 'package:varnika_app/features/core/screens/reels/reels_controller.dart';

class ReelsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReelsController());
  }
}

