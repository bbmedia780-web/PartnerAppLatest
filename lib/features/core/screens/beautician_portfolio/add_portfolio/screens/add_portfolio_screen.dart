import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:varnika_app/constarits/colors.dart';
import 'package:varnika_app/constarits/images.dart';
import 'package:varnika_app/constarits/int_extensions.dart';
import 'package:varnika_app/shared/widgets/app_text_style.dart';
import 'package:varnika_app/shared/widgets/custom_appbar.dart';
import 'package:varnika_app/shared/widgets/custom_button.dart';
import 'package:varnika_app/shared/widgets/custom_dropdown.dart';
import 'package:varnika_app/shared/widgets/custom_textfield.dart';
import 'package:varnika_app/utils/field_validation.dart';
import '../logic/add_portfolio_binding.dart';
import '../logic/add_portfolio_controller.dart';

class AddPortfolioScreen extends StatelessWidget {
  const AddPortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AddPortfolioController>()) {
      AddPortfolioBinding().dependencies();
    }
    final controller = Get.find<AddPortfolioController>();

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: const CustomAppBar(
        title: 'Add Portfolio',
      ),
      body: Form(
        key: controller.formKey,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Picture Section
                  Center(
                    child: Stack(
                      children: [
                        Obx(() => Container(
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                // border: Border.all(color: borderGreyColor, width: 2),
                                image: controller.profileImage.value != null
                                    ? DecorationImage(
                                        image: FileImage(controller.profileImage.value!),
                                        fit: BoxFit.cover,
                                      )
                                    : DecorationImage(
                                        image: AssetImage(AppImages.img3),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            )),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: controller.pickProfileImage,
                            child: Card(
                              elevation: 4,
                             color: whiteColor,
                             borderOnForeground: false,
                             shape: OutlineInputBorder(
                                 borderSide: BorderSide(color: Colors.transparent),
                                 borderRadius: BorderRadius.circular(100)),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: greyDarkLight,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  24.height,
                  // Full Name
                  CustomTextField(
                    labelName: 'Full Name',
                    controller: controller.fullNameController,
                    validator: (value) => Validators().requiredField(value),
                  ),
                  16.height,
                  // Parlour Name
                  CustomTextField(
                    labelName: 'Parlour Name',
                    controller: controller.parlourNameController,
                    validator: (value) => Validators().requiredField(value),
                  ),
                  16.height,
                  // Address
                  CustomTextField(
                    labelName: 'Address',
                    controller: controller.addressController,
                    validator: (value) => Validators().requiredField(value),
                  ),
                  16.height,
                  // About Me
                  CustomTextField(
                    labelName: 'About Me',
                    controller: controller.aboutMeController,
                    isDescription: true,
                    maxLine: 4,
                    validator: (value) => Validators().requiredField(value),
                  ),
                  16.height,
                  // Service Dropdown
                  Text(
                    'Service',
                    style: AppTextStyles.subHeading.copyWith(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: appBlack,
                    ),
                  ),
                  5.height,
                  DecoratedDropdownField(
                    hint: 'Select Service',
                    value: controller.selectedService,
                    items: controller.services,
                    onChanged: controller.onServiceChanged,
                  ),
                  16.height,
                  // Service Images
                  Text(
                    'Service image',
                    style: AppTextStyles.subHeading.copyWith(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: appBlack,
                    ),
                  ),
                  5.height,
                  Obx(() => SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.serviceImages.length + 1,
                          itemBuilder: (context, index) {
                            if (index == controller.serviceImages.length) {
                              // Add More Button
                              return Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: GestureDetector(
                                  onTap: controller.pickServiceImage,
                                  child: Container(
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: borderGreyColor),
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add_photo_alternate_outlined,
                                            color: borderGreyColor,
                                            size: 25,
                                          ),
                                          8.height,
                                          Text(
                                            'Add',
                                            style: AppTextStyles.light.copyWith(
                                              fontSize: 12,
                                              color: greyDarkLight,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                            // Image Item
                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Stack(
                                children: [
                                  Container(
                                    width: 120,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: borderGreyColor),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(
                                        controller.serviceImages[index],
                                        fit: BoxFit.cover,
                                        width: 120,
                                        height: 120,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () => controller.removeServiceImage(index),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: errorColor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          color: whiteColor,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      )),
                  16.height,
                  // Service & Rates
                  CustomTextField(
                    labelName: 'Service & Rates',
                    controller: controller.serviceAndRatesController,
                    validator: (value) => Validators().requiredField(value),
                  ),
                  16.height,
                  // Add photo or video
                  Text(
                    'Add photo or video',
                    style: AppTextStyles.subHeading.copyWith(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: appBlack,
                    ),
                  ),
                  5.height,
                  Obx(() => SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.portfolioPhotoVideos.length + 1,
                          itemBuilder: (context, index) {
                            if (index == controller.portfolioPhotoVideos.length) {
                              // Add More Button
                              return Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: GestureDetector(
                                  onTap: controller.pickPortfolioPhotoVideo,
                                  child: Container(
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: borderGreyColor),
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.cloud_upload_outlined,
                                            color: borderGreyColor,
                                            size: 35,
                                          ),
                                          8.height,
                                          Text(
                                            'Click here\nto upload',
                                            textAlign: TextAlign.center,
                                            style: AppTextStyles.light.copyWith(
                                              fontSize: 12,
                                              color: greyDarkLight,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                            // Image Item
                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Stack(
                                children: [
                                  Container(
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: borderGreyColor),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(
                                        controller.portfolioPhotoVideos[index],
                                        fit: BoxFit.cover,
                                        width: 100,
                                        height: 100,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () => controller.removePortfolioPhotoVideo(index),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: errorColor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          color: whiteColor,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      )),
                  16.height,
                  // My Portfolio
                  CustomTextField(
                    labelName: 'My Portfolio',
                    controller: controller.myPortfolioController,
                    hintText: 'Enter portfolio description',
                  ),
                  100.height,

                ],
              ),
            ),
            Positioned(
              left: 10,
              right: 10,
              bottom: 10,
              child: SafeArea(
                child: CustomButton(
                  title: 'Save',
                  onTap: controller.onSave,
                  isDisable: false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

