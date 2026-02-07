import '../../../../../utils/library_utils.dart';

class RecentActivityCard extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  final String iconPath;
  final Color iconColor;

  const RecentActivityCard({
    super.key,
    required this.title,
    required this.description,
    required this.time,
    required this.iconPath,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                iconPath,
                width: 20,
                height: 20,
                fit: BoxFit.contain,
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
            Text(
              time,
              style: AppTextStyles.light.copyWith(
                fontSize: 11,
                color: txtdarkgrayColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

