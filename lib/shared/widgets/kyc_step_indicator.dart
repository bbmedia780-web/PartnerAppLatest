import '../../../../../utils/library_utils.dart';

class KycStepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> stepLabels;

  const KycStepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.stepLabels,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          // Progress Bar
          // Step Indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(totalSteps, (index) {
              return _buildStepItem(index);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem(int index) {
    final isActive = index == currentStep;
    final isCompleted = index < currentStep;
    final isPending = index > currentStep;

    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                _buildStepCircle(index, isActive, isCompleted, isPending),
                6.height,
                _buildStepLabel(index, isActive, isCompleted, isPending),
              ],
            ),
          ),
          // Connecting Simple Line
          if (index < totalSteps - 1)
            Expanded(
              child: _buildConnectingLine(isCompleted),
            )
          else Expanded(child: SizedBox.shrink())
        ],
      ),
    );
  }

  Widget _buildStepCircle(
    int index,
    bool isActive,
    bool isCompleted,
    bool isPending,
  ) {
    Color circleColor;
    Color textColor;
    Color borderColor;
    double borderWidth;

    if (isCompleted) {
      circleColor = tealColor;
      textColor = whiteColor;
      borderColor = tealColor;
      borderWidth = 0;
    } else if (isActive) {
      circleColor = tealColor;
      textColor = whiteColor;
      borderColor = tealColor;
      borderWidth = 2;
    } else {
      circleColor = whiteColor;
      textColor = txtdarkgrayColor;
      borderColor = borderGreyColor;
      borderWidth = 1.5;
    }

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: circleColor,
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
      ),
      child: Center(
        child: isCompleted
            ? Icon(
                Icons.check,
                color: textColor,
                size: 18,
              )
            : Text(
                '${index + 1}',
                style: AppTextStyles.subHeading.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
      ),
    );
  }

  Widget _buildStepLabel(
    int index,
    bool isActive,
    bool isCompleted,
    bool isPending,
  ) {
    Color textColor;
    FontWeight fontWeight;

    if (isActive || isCompleted) {
      textColor = tealColor;
      fontWeight = FontWeight.w600;
    } else {
      textColor = txtdarkgrayColor;
      fontWeight = FontWeight.w400;
    }

    return Text(
      stepLabels[index],
      style: AppTextStyles.light.copyWith(
        fontSize: 10,
        color: textColor,
        fontWeight: fontWeight,
      ),
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildConnectingLine(bool isCompleted) {
    return Container(
      height: 2,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isCompleted ? tealColor : borderGreyColor,
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }
}
