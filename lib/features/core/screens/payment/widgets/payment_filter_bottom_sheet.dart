import '../../../../../shared/widgets/custom_dropdown.dart';
import '../../../../../shared/widgets/date_selector_field.dart';
import '../../../../../utils/library_utils.dart';

class PaymentFilterBottomSheet extends StatelessWidget {
  const PaymentFilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PaymentController>();

    return SafeArea(
      top: false,
      left: false,
      right: false,
      bottom: true,
      child: Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox.shrink(),
                Text(
                  'Filter',
                  style: AppTextStyles.heading2.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: errorColor.withValues(alpha: 0.1),
                    ),
                    child: Icon(
                      Icons.close,
                      color: errorColor,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1,thickness: 1, color: dividerColor),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date Section
                Text(
                  'Date',
                  style: AppTextStyles.subHeading.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                12.height,
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                        child: Obx(() => DateSelectorField(
                          selectedDate: controller.fromDate.value,
                          onDateSelected: (date) {
                            controller.setFromDate(date);
                          },
                          dateFormat: "dd-MM-yyyy",
                          hintText: 'From',
                        )),
                      ),
                    ),
                    12.width,
                    Text(
                      'To',
                      style: AppTextStyles.subHeading.copyWith(fontSize: 14),
                    ),
                    12.width,
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                        child: Obx(() => DateSelectorField(
                          selectedDate: controller.toDate.value,
                          onDateSelected: (date) {
                            controller.setToDate(date);
                          },
                          dateFormat: "dd-MM-yyyy",
                          hintText: 'To',
                        )),
                      ),
                    ),
                  ],
                ),
                20.height,
                 Text(
                  "Payment Status",
                  style: AppTextStyles.subHeading.copyWith(fontWeight: FontWeight.w600,fontSize: 14),
                ),
                8.height,
                DecoratedDropdownField(
                  hint: "Complete",
                  value: controller.paymentStatus,
                  items: controller.paymentStatusList,
                  onChanged: (val) {
                    controller.paymentStatus.value = val ?? "";
                  },
                ),

                16.height,
                Text(
                  "Payment Mode",
                  style: AppTextStyles.subHeading.copyWith(fontWeight: FontWeight.w600,fontSize: 14),
                ),
                8.height,
                DecoratedDropdownField(
                  hint: "Payment cash",
                  value: controller.paymentMethod,
                  items: controller.paymentMethodList,
                  onChanged: (val) {
                    controller.paymentMethod.value = val ?? "";
                  },
                ),
                24.height,
                // Apply Filter Button
                SafeArea(
                  child: CustomButton(
                    title: 'Apply Filter',
                    onTap: () => controller.applyFilters(),
                    isDisable: false,
                    bgColor: appColor,
                    titleSize: 16,
                    height: 50,
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

}

