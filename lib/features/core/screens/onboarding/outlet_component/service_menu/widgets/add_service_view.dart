import 'dart:io';
import '../../../../../../../utils/library_utils.dart';

class AddServiceDialog extends StatefulWidget {
  final ServiceModel? data;

  const AddServiceDialog({super.key, this.data});

  @override
  State<AddServiceDialog> createState() => _AddServiceDialogState();
}

class _AddServiceDialogState extends State<AddServiceDialog> {
  final TextEditingController serviceNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final ServiceMenuController controller = Get.find<ServiceMenuController>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    /// 🔹 EDIT MODE → PREFILL DATA
    if (widget.data != null) {
      final service = widget.data!;

      serviceNameController.text = service.name;
      priceController.text = service.price;
      descriptionController.text = service.description ?? "";

      controller.isServiceStatus.value =
          service.status.toLowerCase() == "active";

      controller.selectedCategories.value =
          service.category ?? controller.selectedCategories.value;

      /// clear & load images
      controller.selectedImages.clear();
      for (final img in service.images) {
        controller.addExistingImage(img); // 👈 controller method
      }
    }
  }

  @override
  void dispose() {
    serviceNameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.data != null;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
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

            /// 🔹 TITLE
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                Text(
                  isEdit ? "Edit Service" : "Add New Service",
                  style: AppTextStyles.heading2.copyWith(fontSize: 16),
                ),
                InkWell(
                  onTap: Get.back,
                  child: Image.asset(AppImages.closeIcon, height: 25),
                ),
              ],
            ),

            20.height,

            /// 🔹 CATEGORY
            Text(
              "Category",
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: appBlack,
              ),
            ),
            8.height,

            Obx(() {
              return DropdownButtonFormField<String>(
                value: controller.selectedCategories.value.isEmpty
                    ? null
                    : controller.selectedCategories.value,
                decoration: InputDecoration(
                  hintText: "Choose category",
                  border: customFieldBorder,
                  enabledBorder: customFieldBorder,
                ),
                items: controller.lstCategories
                    .map(
                      (item) => DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  ),
                )
                    .toList(),
                onChanged: (value) {
                  controller.selectedCategories.value = value ?? "";
                },
              );
            }),

            12.height,

            /// 🔹 FORM
            Form(
              key: formKey,
              child: Column(
                children: [
                  _buildInput("Service Name", serviceNameController, Icons.spa),
                  8.height,
                  _buildInput(
                      "Price", priceController, Icons.currency_rupee),
                  8.height,
                  CustomTextField(
                    controller: descriptionController,
                    labelName: "Description (optional)",
                    hintText: "Description",
                  ),
                ],
              ),
            ),

            12.height,

            /// 🔹 STATUS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Service Status',
                  style: AppTextStyles.subHeading.copyWith(fontSize: 14),
                ),
                Obx(
                      () => Switch(
                    value: controller.isServiceStatus.value,
                    activeColor: appColor,
                    onChanged: (val) {
                      controller.isServiceStatus.value = val;
                    },
                  ),
                ),
              ],
            ),

            12.height,

            /// 🔹 IMAGES
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Upload Images (optional)',
                  style: AppTextStyles.subHeading.copyWith(fontSize: 14),
                ),
                Obx(() {
                  return controller.selectedImages.isNotEmpty
                      ? GestureDetector(
                    onTap: controller.clearAllImages,
                    child: Text(
                      'Clear All',
                      style: TextStyle(
                          color: errorColor,
                          fontWeight: FontWeight.w600),
                    ),
                  )
                      : const SizedBox();
                }),
              ],
            ),

            12.height,

            _imageSection(),

            24.height,

            /// 🔹 ACTION BUTTONS
            SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      title: "Save",
                      onTap: _onSave,
                      isDisable: false,
                    ),
                  ),
                  10.width,
                  Expanded(
                    child: CustomButton(
                      title: "Cancel",
                      bgColor: borderGreyColor,
                      titleColor: kColorGray,
                      onTap: Get.back,
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

  /// 🔹 IMAGE UI
  Widget _imageSection() {
    return Obx(() {
      return Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          ...controller.selectedImages.asMap().entries.map((entry) {
            final index = entry.key;
            final image = entry.value;

            return Stack(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: borderGreyColor),
                    image: DecorationImage(
                      image: FileImage(image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: GestureDetector(
                    onTap: () =>
                        controller.removeServiceImage(index),
                    child: const CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.red,
                      child: Icon(Icons.close,
                          size: 14, color: Colors.white),
                    ),
                  ),
                )
              ],
            );
          }),

          /// ADD IMAGE
          GestureDetector(
            onTap: controller.showImagePickerDialog,
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderGreyColor),
              ),
              child: const Icon(Icons.add_photo_alternate),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildInput(
      String label, TextEditingController controller, IconData icon) {
    return CustomTextField(
      controller: controller,
      labelName: label,
      hintText: label,
      prefixIcon: Icon(icon, color: Colors.pink),
      validator: (value) => Validators().requiredField(value),
    );
  }

  /// 🔹 SAVE ACTION
  void _onSave() {
    if (!formKey.currentState!.validate()) return;

    final result = ServiceModel(
      name: serviceNameController.text.trim(),
      price: priceController.text.trim(),
      description: descriptionController.text.trim(),
      status: controller.isServiceStatus.value ? "Active" : "Inactive",
      images: controller.getFinalImages(),
      category: controller.selectedCategories.value,
      isSelected: false.obs,
    );

    Get.back(result: result);
  }
}
