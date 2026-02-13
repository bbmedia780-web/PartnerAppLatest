import 'package:get/get.dart';
import 'package:varnika_app/features/core/screens/onboarding/outlet_component/service_menu/logic/service_menu_controller.dart';

class ServiceMenuBinding extends Bindings {
  @override
  void dependencies() {
    return Get.lazyPut(() => ServiceMenuController());
  }
}
