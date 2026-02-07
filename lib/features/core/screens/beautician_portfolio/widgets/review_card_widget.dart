import '../../../../../../utils/library_utils.dart';

class ReviewCardWidget extends StatelessWidget {
  final String userName;
  final String userImage;
  final String timeAgo;
  final int rating;
  final String reviewText;

  const ReviewCardWidget({
    super.key,
    required this.userName,
    required this.userImage,
    required this.timeAgo,
    required this.rating,
    required this.reviewText,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Image
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(userImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          12.width,
          // Review Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row with name, time, and stars
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left side: Name and time
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: AppTextStyles.subHeading.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: blackColor,
                            ),
                          ),
                          2.height,
                          Text(
                            timeAgo,
                            style: AppTextStyles.light.copyWith(
                              fontSize: 11,
                              color: txtdarkgrayColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Right side: Stars in top right
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(5, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 2),
                          child: SizedBox(
                            width: 14,
                            height: 14,
                            child: Image.asset(
                              AppImages.starIcon,
                              color: const Color(0xffFFA439),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
                12.height,
                // Review Text
                Text(
                  reviewText,
                  style: AppTextStyles.regular.copyWith(
                    fontSize: 13,
                    color: blackColor,
                    height: 1.4,
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

