import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:varnika_app/utils/global.dart';
import 'package:varnika_app/utils/image_helpers.dart';

class AddPortfolioController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Text Controllers
  final TextEditingController fullNameController = TextEditingController(text: 'juhi Still');
  final TextEditingController parlourNameController = TextEditingController(text: 'Meera Parlour');
  final TextEditingController addressController = TextEditingController(text: 'Surat, India');
  final TextEditingController aboutMeController = TextEditingController(
    text: 'With 10+ years of experience in the beauty industry, I specialize in bridal makeup, advanced skincare, and trend-focused hairstyling.',
  );
  final TextEditingController serviceAndRatesController = TextEditingController(text: 'juhi Still');
  final TextEditingController myPortfolioController = TextEditingController();

  // Image pickers
  Rx<File?> profileImage = Rx<File?>(null);
  RxList<File> serviceImages = <File>[].obs;
  RxList<File> portfolioPhotoVideos = <File>[].obs;

  // Service dropdown
  final RxString selectedService = 'Facial'.obs;
  final List<String> services = ['Facial', 'Bridal Makeup', 'Mehandi', 'Hair Cutting', 'Hair Styling', 'Nail Art'];

  @override
  void onClose() {
    fullNameController.dispose();
    parlourNameController.dispose();
    addressController.dispose();
    aboutMeController.dispose();
    serviceAndRatesController.dispose();
    myPortfolioController.dispose();
    super.onClose();
  }

  void pickProfileImage() async {
    profileImage.value = await ImagePickerHelper.showPickerDialog(Get.context!);
  }

  void pickServiceImage() async {
    final File? pickedImage = await ImagePickerHelper.showPickerDialog(Get.context!);
    if (pickedImage != null) {
      serviceImages.add(pickedImage);
    }
  }

  void pickMultipleServiceImages() async {
    final List<File> pickedImages = await ImagePickerHelper.pickMultipleImages(Get.context!);
    if (pickedImages.isNotEmpty) {
      serviceImages.addAll(pickedImages);
    }
  }

  void removeServiceImage(int index) {
    if (index >= 0 && index < serviceImages.length) {
      serviceImages.removeAt(index);
    }
  }

  void pickPortfolioPhotoVideo() async {
    final File? pickedImage = await ImagePickerHelper.showPickerDialog(Get.context!);
    if (pickedImage != null) {
      portfolioPhotoVideos.add(pickedImage);
    }
  }

  void pickMultiplePortfolioPhotoVideos() async {
    final List<File> pickedImages = await ImagePickerHelper.pickMultipleImages(Get.context!);
    if (pickedImages.isNotEmpty) {
      portfolioPhotoVideos.addAll(pickedImages);
    }
  }

  void removePortfolioPhotoVideo(int index) {
    if (index >= 0 && index < portfolioPhotoVideos.length) {
      portfolioPhotoVideos.removeAt(index);
    }
  }

  void onServiceChanged(String? value) {
    if (value != null) {
      selectedService.value = value;
    }
  }


  void onSave() {
    if (formKey.currentState?.validate() ?? false) {
      // Save portfolio data
      ShowToast.success('Portfolio saved successfully');
      Get.back();
    }
  }
}

