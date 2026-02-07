import 'package:get/get.dart';
import 'add_portfolio_controller.dart';

class AddPortfolioBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddPortfolioController());
  }
}

