import '../../../../../../utils/library_utils.dart';

class KycVerificationScreen extends StatelessWidget {
  const KycVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller if not already registered
    if (!Get.isRegistered<KycVerificationController>()) {
      KycVerificationBinding().dependencies();
    }
    final controller = Get.find<KycVerificationController>();

    final stepLabels = ['Aadhaar', 'PAN', 'GSTIN', 'Bank'];

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: CustomAppBar(
        title: 'KYC Verification',

      ),
      body: Column(
        children: [
          // Step Indicator
          KycStepIndicator(
            currentStep: controller.currentStep.value,
            totalSteps: controller.totalSteps,
            stepLabels: stepLabels,
          ),

          Align(
            alignment: Alignment.topLeft,
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                color: kColorGray,
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                widthFactor: (controller.currentStep.value + 1) / controller.totalSteps,
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    color: tealColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
          20.height,
          // Step Content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => KycVerificationStepWidget(
                        stepIndex: controller.currentStep.value,
                        controller: controller,
                      )),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Navigation Buttons
          // Container(
          //   padding: EdgeInsets.only(left: 15,right: 15,top: 10,bottom: 10),
          //   decoration: BoxDecoration(
          //     color: whiteColor,
          //     boxShadow: [
          //       BoxShadow(
          //         color: Colors.black.withValues(alpha: 0.05),
          //         blurRadius: 10,
          //         offset: const Offset(0, -2),
          //       ),
          //     ],
          //   ),
          //   child: SafeArea(
          //     child: Obx(() => Row(
          //           children: [
          //             if (controller.currentStep.value > 0)
          //               Expanded(
          //                 child: OutlinedButton(
          //                   onPressed: controller.previousStep,
          //                   style: OutlinedButton.styleFrom(
          //                     padding: const EdgeInsets.symmetric(vertical: 12),
          //                     side: BorderSide(color: dividerColor, width: 1.5),
          //                     shape: RoundedRectangleBorder(
          //                       borderRadius: BorderRadius.circular(12),
          //                     ),
          //                   ),
          //                   child: Row(
          //                     mainAxisAlignment: MainAxisAlignment.center,
          //                     children: [
          //                       const Icon(Icons.arrow_back_ios, size: 14, color: blackColor),
          //                       6.width,
          //                       Text(
          //                         'Previous',
          //                         style: AppTextStyles.subHeading.copyWith(
          //                           fontSize: 14,
          //                           fontWeight: FontWeight.w600,
          //                           color: blackColor,
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //             if (controller.currentStep.value > 0) 12.width,
          //             if (controller.currentStep.value < controller.totalSteps - 1)
          //               Expanded(
          //                 child: ElevatedButton(
          //                   onPressed: controller.canProceedToNext()
          //                       ? controller.nextStep
          //                       : null,
          //                   style: ElevatedButton.styleFrom(
          //                     backgroundColor: tealColor,
          //                     padding: const EdgeInsets.symmetric(vertical: 12),
          //                     shape: RoundedRectangleBorder(
          //                       borderRadius: BorderRadius.circular(12),
          //                     ),
          //                     disabledBackgroundColor: txtdarkgrayColor,
          //                     elevation: 0,
          //                   ),
          //                   child: Row(
          //                     mainAxisAlignment: MainAxisAlignment.center,
          //                     children: [
          //                       Text(
          //                         'Next',
          //                         style: AppTextStyles.button.copyWith(
          //                           fontSize: 14,
          //                           fontWeight: FontWeight.w600,
          //                           color: whiteColor,
          //                         ),
          //                       ),
          //                       6.width,
          //                       const Icon(Icons.arrow_forward_ios, size: 14, color: whiteColor),
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //           ],
          //         )),
          //   ),
          // ),
        ],
      ),
    );
  }
}
