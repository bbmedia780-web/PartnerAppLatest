import 'package:get/get.dart';
import 'package:varnika_app/features/core/screens/auth/sign_in/logic/sign_in_controller.dart';

class SignInBinding extends Bindings {
  @override
  void dependencies() {
    return Get.lazyPut(() => SignInController());
  }
}
