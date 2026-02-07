import 'dart:io';
import '../../../../../../../utils/library_utils.dart';

class AddServiceDialog extends StatelessWidget {
  final TextEditingController serviceName = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final ServiceMenuController controller = Get.find<ServiceMenuController>();
  final RxBool isValid = false.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  AddServiceDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: kColorGray.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          16.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox.shrink(),
              Text(
                "Add New Service",
                style: AppTextStyles.heading2.copyWith(fontSize: 16),
              ),
              InkWell(
                  onTap: (){
                    Get.back();
                  },
                  child: Image.asset(AppImages.closeIcon,height: 25,width: 25,))
            ],
          ),

          20.height,
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              "Category",
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: appBlack),
            ),
          ),
          DropdownButtonFormField<String>(
            value: controller.selectedCategories.value,
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
            decoration: InputDecoration(
                hintText: "Choose your outlet type",
                hintStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: kColorGray),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                filled: false,
                fillColor: whiteColor,
                border: customFieldBorder,
                enabledBorder: customFieldBorder,
                errorBorder: customFieldBorder,
                focusedBorder: customFieldBorder
            ),
            items: controller.lstCategories
                .map(
                  (item) => DropdownMenuItem(
                value: item,
                child: Text(item, style: const TextStyle(fontSize: 15)),
              ),
            )
                .toList(),
            onChanged: (value) {
              controller.selectedCategories.value = value??"";
            },
          ),
          12.height,
          Form(
            key: formKey,
            child: Column(
              children: [
                _buildInput("Service Name", serviceName, Icons.spa),
                8.height,
                CustomTextField(
                  controller: descriptionController,
                  hintText: "Description",
                  labelName: 'Description (optional)',
                ),
              ],
            ),
          ),
          12.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Service status (Active/Inactive)',
                style: AppTextStyles.subHeading.copyWith(fontSize: 14),
              ),
              Obx(() {
                return Transform.scale(
                  scale: 0.7,
                  child: Switch(
                    activeColor: appColor,
                    value: controller.isServiceStatus.value,
                    onChanged: (value) {
                      controller.isServiceStatus.value =
                      !controller.isServiceStatus.value;
                    },
                  ),
                );
              }),
            ],
          ),
          12.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Upload Images (optional)',
                style: AppTextStyles.subHeading.copyWith(fontSize: 14),
              ),
              Obx(() {
                if (controller.selectedImages.isNotEmpty) {
                  return GestureDetector(
                    onTap: () {
                      controller.clearAllImages();
                    },
                    child: Text(
                      'Clear All',
                      style: AppTextStyles.regular.copyWith(
                        fontSize: 12,
                        color: errorColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }
                return SizedBox.shrink();
              }),
            ],
          ),
          12.height,
          Obx(() {
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                // Display selected images
                ...controller.selectedImages.asMap().entries.map((entry) {
                  int index = entry.key;
                  File imageFile = entry.value;
                  return Stack(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: borderGreyColor),
                          image: DecorationImage(
                            image: FileImage(imageFile),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            controller.removeServiceImage(index);
                          },
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: errorColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: whiteColor, width: 2),
                            ),
                            child: Icon(
                              Icons.close,
                              color: whiteColor,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
                // Add image button
                GestureDetector(
                  onTap: () {
                    // Show dialog to choose single or multiple
                    Get.dialog(
                      AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        title: Text(
                          "Add Images",
                          style: AppTextStyles.heading2.copyWith(fontSize: 16),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: Icon(Icons.add_photo_alternate, color: appColor),
                              title: Text("Add Single Image"),
                              onTap: () async {
                                Get.back();
                                await controller.pickSingleServiceImage();
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.photo_library, color: appColor),
                              title: Text("Add Multiple Images"),
                              onTap: () async {
                                Get.back();
                                await controller.pickMultipleServiceImages();
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: borderGreyColor, style: BorderStyle.solid),
                      color: kColorGray.withValues(alpha: 0.2),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate,
                          color: kColorGray,
                          size: 30,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Add',
                          style: AppTextStyles.regular.copyWith(
                            fontSize: 10,
                            color: kColorGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
          25.height,
          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomButton(
                    title: "Save",
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        Get.back(result: {"name": serviceName.text.trim()});
                      }
                    },
                    isDisable: false,
                  ),
                ),
                10.width,
                Expanded(
                  child: CustomButton(
                    bgColor: borderGreyColor,
                    title: "Cancel",
                    onTap: (){
                      Get.back();
                    },
                    isOutLineBorder: false,
                    titleColor: kColorGray,
                    isDisable: false,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildInput(
      String label,
      TextEditingController controller,
      IconData icon,
      ) {
    controller.addListener(() => isValid.refresh());

    return CustomTextField(
      controller: controller,
      hintText: label,
      prefixIcon: Icon(icon, color: Colors.pink),
      labelName: label,
      validator: (value) => Validators().requiredField(value),
    );
  }
}
