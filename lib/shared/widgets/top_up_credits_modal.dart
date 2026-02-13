
import '../../../../../utils/library_utils.dart';

class TopUpCreditsModal extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
   TopUpCreditsModal({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppPromotionController>();
    final currentBalance = controller.adCreditBalance.value;

    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: appColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Image.asset(
                      AppImages.cardIcon,
                      width: 24,
                      height: 24,
                      color: appColor,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Top up credits',
                        style: AppTextStyles.subHeading.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: blackColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Current balance: ₹${currentBalance.toStringAsFixed(0)}',
                        style: AppTextStyles.light.copyWith(
                          fontSize: 12,
                          color: txtdarkgrayColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Select amount label
            Text(
              'Select amount to add',
              style: AppTextStyles.subHeading.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: blackColor,
              ),
            ),
            const SizedBox(height: 16),
            // Amount selection buttons
            Obx(() => Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildAmountButton(
                      amount: 500,
                      selectedAmount: controller.selectedAmount.value,
                      isCustom: false,
                      isSelected: controller.selectedAmount.value == 500 && !controller.isCustomAmount.value,
                      onTap: () => controller.selectAmount(500), context: context,
                    ),
                    _buildAmountButton(
                      amount: 1000,
                      selectedAmount: controller.selectedAmount.value,
                      isCustom: false,
                      isSelected: controller.selectedAmount.value == 1000 && !controller.isCustomAmount.value,
                      onTap: () => controller.selectAmount(1000),
                        context: context
                    ),
                    _buildAmountButton(
                      amount: 2000,
                      selectedAmount: controller.selectedAmount.value,
                      isCustom: false,
                      isSelected: controller.selectedAmount.value == 2000 && !controller.isCustomAmount.value,
                      onTap: () => controller.selectAmount(2000),
                        context: context
                    ),
                    _buildAmountButton(
                      amount: 5000,
                      selectedAmount: controller.selectedAmount.value,
                      isCustom: false,
                      isSelected: controller.selectedAmount.value == 5000 && !controller.isCustomAmount.value,
                      onTap: () => controller.selectAmount(5000),
                        context: context
                    ),
                    _buildAmountButton(
                      amount: 10000,
                      selectedAmount: controller.selectedAmount.value,
                      isCustom: false,
                      isSelected: controller.selectedAmount.value == 10000 && !controller.isCustomAmount.value,
                      onTap: () => controller.selectAmount(10000),
                        context: context
                    ),
                    _buildAmountButton(
                      amount: 0,
                      selectedAmount: controller.selectedAmount.value,
                      isCustom: true,
                      isSelected: controller.isCustomAmount.value,
                      onTap: () => controller.selectCustomAmount(),
                        context: context
                    ),
                  ],
                )),
            // Custom amount input
            Obx(() => controller.isCustomAmount.value
                ? Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Form(
                      key: formKey,
                      child: CustomTextField(
                        labelName: '',
                        controller: controller.customAmountController,
                        textInputType: TextInputType.number,
                        hintText: 'Enter custom amount',
                        borderRadius: 12,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: borderGreyColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: tealColor),
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 16, top: 10),
                          child: Text('₹ ', style: TextStyle(color: blackColor, fontSize: 14)),
                        ),
                        validator: (value) {
                          if (controller.isCustomAmount.value) {
                            return Validators().requiredField(value);
                          }
                          return null;
                        },
                      ),
                    ),
                  )
                : const SizedBox.shrink()),
            const SizedBox(height: 16),
            // Information message
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: yellowColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: yellowColor.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: yellowColor, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Credits are used for running promotions and will be deducated based on your daily budget.',
                      style: AppTextStyles.light.copyWith(
                        fontSize: 12,
                        color: blackColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Action buttons
            SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: controller.closeTopUpModal,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: borderGreyColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: AppTextStyles.subHeading.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: blackColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (controller.isCustomAmount.value) {
                          if (formKey.currentState!.validate()) {
                            controller.proceedTopUp();
                          }
                        } else {
                          controller.proceedTopUp();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: tealColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Proceed',
                        style: AppTextStyles.button.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: whiteColor,
                        ),
                      ),
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

  Widget _buildAmountButton({
    required double amount,
    required double selectedAmount,
    required bool isCustom,
    required VoidCallback onTap,
    required bool isSelected,
    required BuildContext context
  }) {

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: ((MediaQuery.of(context).size.width) - 64) / 3 - 8,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? tealColor : whiteColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? tealColor : borderGreyColor,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            isCustom ? 'Custom' : '₹${amount.toStringAsFixed(0)}',
            style: AppTextStyles.subHeading.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? whiteColor : blackColor,
            ),
          ),
        ),
      ),
    );
  }
}

