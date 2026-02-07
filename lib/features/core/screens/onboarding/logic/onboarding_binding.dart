import 'package:get/get.dart';
import 'package:varnika_app/features/core/screens/auth/sign_in/logic/sign_in_controller.dart';
import 'package:varnika_app/features/core/screens/onboarding/logic/onboarding_controller.dart';
import 'package:varnika_app/features/core/screens/onboarding/outlet_component/outlet_documents/kyc_controller.dart';

import '../outlet_component/outlet_documents/verification_services.dart';

  class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
     Get.lazyPut(() => OnBoardingController());
     Get.lazyPut(() => KycController());
     Get.lazyPut(() => VerificationService());
  }
}
