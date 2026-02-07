
import '../../../../../../utils/library_utils.dart';

class ReferEarnBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReferEarnController>(() => ReferEarnController());
  }
}

