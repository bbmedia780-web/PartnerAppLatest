import '../../../../utils/library_utils.dart';

class OnBoardingScreen extends GetView<OnBoardingController> {
  const OnBoardingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    OnBoardingController controller = Get.put(OnBoardingController());
    return Scaffold(
      backgroundColor: whiteColor,
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: (MediaQuery.of(context).size.height) * 0.38,
                width: (MediaQuery.of(context).size.width),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppImages.img4),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.3),
                        Colors.black.withValues(alpha: 0.5),
                        Colors.black.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 20,
                top: 60,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // GestureDetector(
                    //   onTap: () => Get.back(),
                    //   child: Icon(
                    //     Icons.arrow_back_ios,
                    //     color: Colors.white,
                    //     size: 20,
                    //   ),
                    // ),
                    // SizedBox(height: 20),
                    Text(
                      "Let's finish\nonboarding you!",
                      style: AppTextStyles.heading1.copyWith(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "In less than 10 minutes",
                      style: AppTextStyles.heading1.copyWith(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: (MediaQuery.of(context).size.width),
                  height: 15,
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(color: whiteColor),
              child: SingleChildScrollView(
                child: _buildStepsList(controller),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          height: 30,
          child: Center(
            child: Text(
              "If you need any help, check out the FAQs",
              style: AppTextStyles.heading1.copyWith(
                fontSize: 13,
                color: Colors.black45,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepsList(OnBoardingController controller) {
    return Obx(() {
      final steps = [
        _StepData(
          stepNumber: 1,
          title: "Parlour information",
          description: "Location, owner details, open & close hrs.",
          isCompleted: controller.step1.value,
          onTap: () => Get.to(() => OutletInformationView()),
        ),
        _StepData(
            stepNumber: 2,
            title: "Parlour Documents",
            description: "Licenses, identity and compliance",
            isCompleted: controller.step2.value,
            // onTap: () => Get.to(() => OutletDocumentsScreen()),
            onTap: () => Get.toNamed(AppRoutes.kycVerification)
        ),
        _StepData(
          stepNumber: 3,
          title: "Service menu setup",
          description: "Add services, durations, and pricing",
          isCompleted: controller.step3.value,
          onTap: () => Get.toNamed(AppRoutes.serviceMenu),
        ),
        _StepData(
          stepNumber: 4,
          title: "Partner contract",
          description: "Review and sign digitally",
          isCompleted: controller.step4.value,
          onTap:() => Get.toNamed(AppRoutes.dashboard),
        ),
      ];

      return Column(
        children: List.generate(steps.length, (index) {
          final step = steps[index];
          final isLast = index == steps.length - 1;
          return _buildStepItem(step, isLast, controller);
        }),
      );
    });
  }

  Widget _buildStepItem(_StepData step, bool isLast, OnBoardingController controller) {
    return Obx(() {
      final isCompleted = _getStepCompletionStatus(step.stepNumber, controller);
      final isButtonEnabled = _isStepEnabled(step.stepNumber, controller);
      return Padding(
        padding: EdgeInsets.only(bottom: isLast ? 0 : 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted ?appColor : Colors.transparent,
                    border: Border.all(
                      color: appColor,
                      width: 2,
                    ),
                  ),
                  child: isCompleted
                      ? Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  )
                      : Center(child: Text(step.stepNumber.toString(),)),
                ),
                // Dashed line (only if not last)
                if (!isLast)
                  Container(
                    width: 2,
                    height: 65,
                    margin: EdgeInsets.symmetric(vertical: 4),
                    child: CustomPaint(
                      painter: DashedLinePainter(),
                    ),
                  ),
              ],
            ),
            16.width,
            // Step content
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Step ${step.stepNumber}",
                      style: AppTextStyles.regular.copyWith(
                        fontSize: 12,
                        color: Colors.black54,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    4.height,
                    Text(
                      step.title,
                      style: AppTextStyles.heading2.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: blackColor,
                      ),
                    ),
                    4.height,
                    Text(
                      step.description,
                      style: AppTextStyles.regular.copyWith(
                        fontSize: 12,
                        color: Colors.black54,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Proceed button - show only if enabled
            if (isButtonEnabled)
              Padding(
                padding: EdgeInsets.only(top: 2),
                child: GestureDetector(
                  onTap: step.onTap,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: appColor, // Teal color
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isCompleted ? "Edit" : "Proceed",
                          style: AppTextStyles.regular.copyWith(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        4.width,
                        Icon(
                          isCompleted ? Icons.edit : Icons.arrow_forward_ios_outlined,
                          color: Colors.white,
                          size: 12,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }

  // Helper method to get step completion status
  bool _getStepCompletionStatus(int stepNumber, OnBoardingController controller) {
    switch (stepNumber) {
      case 1:
        return controller.step1.value;
      case 2:
        return controller.step2.value;
      case 3:
        return controller.step3.value;
      case 4:
        return controller.step4.value;
      default:
        return false;
    }
  }

  bool _isStepEnabled(int stepNumber, OnBoardingController controller) {
    switch (stepNumber) {
      case 1:
        return true;
      case 2:
        return true;
        // return controller.step1.value;
      case 3:
      // Step 3 is enabled only if Step 2 is completed
        return true;
        // return controller.step2.value;
      case 4:
      // Step 4 is enabled only if Step 3 is completed
        return true;
        // return controller.step3.value;
      default:
        return false;
    }
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = appColor.withValues(alpha:0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dashHeight = 4;
    const dashSpace = 4;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _StepData {
  final int stepNumber;
  final String title;
  final String description;
  final bool isCompleted;
  final VoidCallback onTap;

  _StepData({
    required this.stepNumber,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.onTap,
  });
}
