import '../../../../../../utils/library_utils.dart';

class ReviewCard extends StatelessWidget {
  final ReviewModel review;

  const ReviewCard({
    super.key,
    required this.review,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Image
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: appColor.withOpacity(0.05),
                ),
                child: Center(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(review.userImage,color: appColor,),
                ),),
              ),
              12.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: AppTextStyles.subHeading.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: blackColor,
                      ),
                    ),
                    4.height,
                    Row(
                      children: [
                        _buildStars(review.rating),
                        8.width,
                        Text(
                          review.timeAgo,
                          style: AppTextStyles.light.copyWith(
                            fontSize: 11,
                            color: txtdarkgrayColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // More Options Icon
              IconButton(
                icon: const Icon(
                  Icons.more_vert,
                  size: 20,
                  color: txtdarkgrayColor,
                ),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          12.height,
          // Review Text
          Text(
            review.reviewText,
            style: AppTextStyles.regular.copyWith(
              fontSize: 13,
              color: blackColor,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStars(int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating) {
          return const Icon(Icons.star, color: appColor, size: 14);
        } else {
          return const Icon(Icons.star_border, color: kColorGray, size: 14);
        }
      }),
    );
  }
}

