import '../../../../../../utils/library_utils.dart';

class RatingSummaryCard extends StatelessWidget {
  final RatingSummary ratingSummary;

  const RatingSummaryCard({
    super.key,
    required this.ratingSummary,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Row(
        children: [
          // Star Distribution
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStarRow(5, ratingSummary.ratingDistribution[5] ?? 0),
                4.height,
                _buildStarRow(4, ratingSummary.ratingDistribution[4] ?? 0),
                4.height,
                _buildStarRow(3, ratingSummary.ratingDistribution[3] ?? 0),
                4.height,
                _buildStarRow(2, ratingSummary.ratingDistribution[2] ?? 0),
                4.height,
                _buildStarRow(1, ratingSummary.ratingDistribution[1] ?? 0),
              ],
            ),
          ),
          20.width,
          // Overall Rating
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                ratingSummary.averageRating.toStringAsFixed(1),
                style: AppTextStyles.heading1.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: blackColor,
                ),
              ),
              8.height,
              _buildStars(ratingSummary.averageRating),
              8.height,
              Text(
                '${ratingSummary.totalReviews} Reviews',
                style: AppTextStyles.regular.copyWith(
                  fontSize: 12,
                  color: txtdarkgrayColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStarRow(int stars, int count) {
    final total = ratingSummary.totalReviews;
    final percentage = total > 0 ? count / total : 0.0;

    return Row(
      children: [
        Text(
          '$stars ★',
          style: AppTextStyles.regular.copyWith(
            fontSize: 12,
            color: appColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        8.width,
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
                  color: appColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStars(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        if (starValue <= rating.floor()) {
          return Icon(Icons.star, color: appColor, size: 20);
        } else if (starValue - 0.5 <= rating) {
          return Icon(Icons.star_half, color: appColor, size: 20);
        } else {
          return Icon(Icons.star_border, color: kColorGray, size: 20);
        }
      }),
    );
  }
}

