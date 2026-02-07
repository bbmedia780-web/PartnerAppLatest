import '../../../../../../utils/library_utils.dart';

class SignUpBinding extends Bindings {
  @override
  void dependencies() {
    return Get.lazyPut(() => SignUpController());
  }
}
