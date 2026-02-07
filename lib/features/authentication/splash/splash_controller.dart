import '../../../utils/library_utils.dart';

class SplashController extends GetxController {

  initial() async {
    // getFcmToken();
    await Future.delayed(const Duration(seconds: 2)).whenComplete(() async {
      Get.toNamed(AppRoutes.signIn);
    });
  }

  // getFcmToken() async {
  //   String? token = await FirebaseMessaging.instance.getToken();
  //   setString(preFcmToken, token ?? "");
  // }
}
