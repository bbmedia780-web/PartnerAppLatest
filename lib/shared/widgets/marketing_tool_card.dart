import '../../../../../utils/library_utils.dart';

class MarketingToolCard extends StatelessWidget {
  final String title;
  final String description;
  final String iconPath;
  final Color iconColor;
  final VoidCallback? onTap;

  const MarketingToolCard({
    super.key,
    required this.title,
    required this.description,
    required this.iconPath,
    required this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: borderGreyColor,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha:0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                iconPath,
                width: 24,
                height: 24,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 12),
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
                  const SizedBox(height: 4),
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
            Image.asset(
              AppImages.arrowIcon,
              width: 16,
              height: 16,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}

