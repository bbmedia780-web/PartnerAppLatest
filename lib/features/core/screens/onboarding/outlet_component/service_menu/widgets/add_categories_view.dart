import 'dart:io';
import '../../../../../../../utils/library_utils.dart';

class AddCategoryDialog extends StatelessWidget {
  final TextEditingController categoryName = TextEditingController();
  final ServiceMenuController controller = Get.find<ServiceMenuController>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  AddCategoryDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
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
                  "Add New Category",
                  style: AppTextStyles.subHeading.copyWith(fontSize: 18),
                ),
                InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Image.asset(AppImages.closeIcon,height: 25,width: 25,))
              ],
            ),
            12.height,

            Form(
              key: formKey,
              child: CustomTextField(
                controller: categoryName,
                hintText: "Category name",
                prefixIcon: Icon(Icons.category, color: Colors.pink),
                labelName: 'Category Name',
                validator: (value) => Validators().requiredField(value),
              ),
            ),
            12.height,
            Text(
              'Upload Image (option)',
              style: AppTextStyles.subHeading.copyWith(fontSize: 14),
            ),
            12.height,
            Obx(() {
              return GestureDetector(
                onTap: () {
                  controller.pickServiceImages();
                },
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: borderGreyColor),
                    image: controller.selectedImage.value.path.isNotEmpty
                        ? DecorationImage(
                            image: FileImage(controller.selectedImage.value),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: controller.selectedImage.value.path.isNotEmpty
                      ? Stack(
                          children: [
                            // Close button
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    controller.selectedImage.value = File("");
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: errorColor,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Icon(
                                        Icons.close_sharp,
                                        color: whiteColor,
                                        size: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                AppImages.uploadImage,
                                color: kColorGray,
                                height: 30,
                                width: 30,
                              ),
                              4.height,
                              Text(
                                'Upload',
                                style: AppTextStyles.regular.copyWith(fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                ),
              );
            }),
            // Obx(() => GestureDetector(
            //   onTap: controller.pickServiceImages,
            //   child: Container(
            //     height: 140,
            //     width: double.infinity,
            //     decoration: BoxDecoration(
            //       border: Border.all(color: kColorGray.shade300),
            //       color: Colors.white,
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //     child: controller.selectedImage.value.path.isEmpty
            //         ? Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: const [
            //         Icon(Icons.image, size: 48),
            //         SizedBox(height: 8),
            //         Text("Tap to add image"),
            //       ],
            //     )
            //         : ClipRRect(
            //       borderRadius: BorderRadius.circular(12),
            //       child: Image.file(
            //         controller.selectedImage.value!,
            //         fit: BoxFit.cover,
            //       ),
            //     ),
            //   ),
            // )),

            20.height,

            // Services section header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => Text(
                  "Services (${controller.services.length})",
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 16),
                )),
                GestureDetector(
                  onTap: controller.addService,
                  child: Text(
                    "+ Add Service",
                    style: AppTextStyles.subHeading.copyWith(
                        color: appColor,
                        fontSize: 16,
                        ),
                  ),
                ),
              ],
            ),

           10.height,
            Obx(() => Column(
              children: List.generate(
                controller.services.length,
                    (index) => _serviceTile(index, controller),
              ),
            )),

            20.height,
            SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      title: "Save",
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          Get.back(result: categoryName.text.trim());
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
                      titleColor: kColorGray,
                      onTap: () {
                        Get.back(result: categoryName.text.trim());
                      },
                      isDisable: false,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _serviceTile(int index, ServiceMenuController controller) {
    return Card(
      color: whiteColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CustomTextField(
              controller: TextEditingController(),
              hintText: "Service Name",
              labelName: 'Service Name',
              fillColor: whiteColor,
              onChange: (val) => controller.services[index]["name"] = val,
            ),
            10.height,
            CustomTextField(
              controller: TextEditingController(),
              hintText: "Description",
              labelName: 'Description (Optional)',
              fillColor: whiteColor,
              onChange: (val) => controller.services[index]["desc"] = val,
            ),
           10.height,
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Service Images (option)',
                style: AppTextStyles.subHeading.copyWith(fontSize: 14),
              ),
            ),
            5.height,
            Align(
              alignment: Alignment.topLeft,
              child: Obx(() {
                final images = controller.getServiceImages(index);

                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    /// Show selected images
                    ...List.generate(images.length, (imageIndex) {
                      return Stack(
                        children: [
                          Container(
                            height: 110,
                            width: 110,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: borderGreyColor),
                              image: DecorationImage(
                                image: FileImage(images[imageIndex]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          /// Remove button
                          Positioned(
                            top: 4,
                            right: 4,
                            child: InkWell(
                              onTap: () {
                                controller.removeServiceImageAtIndex(index, imageIndex);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: errorColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),

                    /// Add More / Upload button
                    GestureDetector(
                      onTap: () => controller.pickMultipleServiceImagesForIndex(index),
                      child: Container(
                        height: 110,
                        width: 110,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: borderGreyColor),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              size: 30,
                              color: kColorGray,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              images.isEmpty ? 'Upload' : 'Add More',
                              style: AppTextStyles.regular.copyWith(fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),

            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => controller.removeService(index),
                child: const Icon(Icons.delete, color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
