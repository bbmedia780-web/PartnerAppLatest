import '../../../../../../utils/library_utils.dart';

class HowItWorksStep extends StatelessWidget {
  final String iconPath;
  final String title;
  final String description;

  const HowItWorksStep({
    super.key,
    required this.iconPath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: appColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                iconPath,
                width: 24,
                height: 24,
                color: appColor,
              ),
            ),
          ),
          12.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.subHeading.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: blackColor,
                  ),
                ),
                4.height,
                Text(
                  description,
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
    );
  }
}

