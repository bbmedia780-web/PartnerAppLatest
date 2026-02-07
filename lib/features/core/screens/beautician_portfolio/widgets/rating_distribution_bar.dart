
import '../../../../../../utils/library_utils.dart';

class RatingDistributionBar extends StatelessWidget {
  final int rating;
  final int count;
  final int maxCount;

  const RatingDistributionBar({
    super.key,
    required this.rating,
    required this.count,
    required this.maxCount,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = maxCount > 0 ? count / maxCount : 0.0;

    return Row(
      children: [
        // Rating number
        Text(
          '$rating.0',
          style: AppTextStyles.regular.copyWith(
            fontSize: 12,
            color: blackColor,
          ),
        ),
        8.width,
        // Star icon
        SizedBox(
          height: 16,
          width: 16,
          child: Image.asset(
            AppImages.starIcon,
            color: const Color(0xffFFA439),
          ),
        ),
        12.width,
        // Bar graph
        Expanded(
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              color: kColorGray.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage,
              child: Container(
                decoration: BoxDecoration(
                  color: count > 0 ? blackColor : kColorGray.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
        12.width,
        // Count
        Text(
          count.toString(),
          style: AppTextStyles.regular.copyWith(
            fontSize: 12,
            color: blackColor,
          ),
        ),
      ],
    );
  }
}

