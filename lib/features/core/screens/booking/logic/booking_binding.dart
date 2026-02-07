import '../../../../../../utils/library_utils.dart';

class BookingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BookingController());
  }
}

