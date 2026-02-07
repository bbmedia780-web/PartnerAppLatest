import '../../../../../../utils/library_utils.dart';

class KycVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => KycVerificationController());
  }
}

