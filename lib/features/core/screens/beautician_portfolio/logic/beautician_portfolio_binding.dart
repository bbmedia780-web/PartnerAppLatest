import 'package:get/get.dart';
import 'beautician_portfolio_controller.dart';

class BeauticianPortfolioBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BeauticianPortfolioController>(() => BeauticianPortfolioController());
  }
}

