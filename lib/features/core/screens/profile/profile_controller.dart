import 'dart:io';
import 'package:varnika_app/utils/image_helpers.dart';

import '../../../../../../utils/library_utils.dart';

class ProfileController extends GetxController {
  TextEditingController userNameController=TextEditingController();
  TextEditingController phoneNumberController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  Rx<File?> profileImage = Rx<File?>(null);
  final ImagePicker picker = ImagePicker();

  var userName = 'User name'.obs;
  var phoneNumber = '98456 45923'.obs;


  /// edit profile
  void onEditProfile() {
    Get.toNamed(AppRoutes.editProfile);
  }
  void pickProfileImage()async{
    profileImage.value = await ImagePickerHelper.showPickerDialog(Get.context!) ?? File("");
    if (profileImage.value!=null) {
      debugPrint("Image Path: ${profileImage.value?.path}");
    } else {
      debugPrint("No image selected");
    }
  }

  void onBusinessInformation() {
    Get.toNamed(AppRoutes.outletInformation);
  }

  void onService() {
    Get.toNamed(AppRoutes.serviceList);
  }

  void onWallet() {
    Get.toNamed(AppRoutes.wallet);
  }

  void onNotification() {
    Get.toNamed(AppRoutes.notifications);
  }


  void onHelpSupport() {
    // Navigate to help & support screen
  }

  void onPaymentHistory() {
    Get.toNamed(AppRoutes.paymentHistory);
  }

  void onReferEarn() {
    Get.toNamed(AppRoutes.referEarn);
  }

  void onBeauticianPortfolio() {
    Get.toNamed(AppRoutes.beauticianPortfolio);
  }

  void onAddPortfolio() {
    Get.toNamed(AppRoutes.addPortfolio);
  }
}

