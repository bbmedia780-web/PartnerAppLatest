import '../../../../../utils/library_utils.dart';

class QuickStatsCard extends StatelessWidget {
  final String value;
  final String label;
  final String iconPath;
  final Color valueColor;
  final Color iconBackgroundColor;

  const QuickStatsCard({
    super.key,
    required this.value,
    required this.label,
    required this.iconPath,
    required this.valueColor,
    required this.iconBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      radius: 10,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max, // ⭐ KEY LINE
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.heading2.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: valueColor,
                  ),
                ),
                6.height,
                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.subHeading.copyWith(
                    fontSize: 12,
                    color: txtdarkgrayColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          10.width,
          Container(
            width: 40,
            height: 40,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(
              iconPath,
              fit: BoxFit.contain,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

