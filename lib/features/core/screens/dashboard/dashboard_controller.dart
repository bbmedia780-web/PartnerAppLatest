import '../../../../../../utils/library_utils.dart';

class DashboardController extends GetxController {

  var currentIndex = 0.obs;

  void changeIndex(int index) {
    currentIndex.value = index;
    if (Get.isRegistered<ReelsController>()) {
      Get.find<ReelsController>()
          .updateActivation(index == 3); // 2 = reels tab
    }
  }
}

