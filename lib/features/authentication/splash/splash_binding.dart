import '../../../utils/library_utils.dart';

class SplashBindings extends Bindings {
  @override
  void dependencies() {
     Get.lazyPut(() => SplashController());
     Get.lazyPut(() => DashboardController());
     Get.lazyPut(() => HomeController());
  }
}
