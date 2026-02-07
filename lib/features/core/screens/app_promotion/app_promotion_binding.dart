import 'package:get/get.dart';
import 'app_promotion_controller.dart';

class AppPromotionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AppPromotionController());
  }
}

