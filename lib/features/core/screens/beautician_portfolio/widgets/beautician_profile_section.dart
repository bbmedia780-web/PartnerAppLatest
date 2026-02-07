
import '../../../../../../utils/library_utils.dart';

class BeauticianProfileSection extends StatelessWidget {
  final String beauticianName;
  final String businessName;
  final double rating;
  final int totalReviews;
  final String location;

  const BeauticianProfileSection({
    super.key,
    required this.beauticianName,
    required this.businessName,
    required this.rating,
    required this.totalReviews,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Profile Picture
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            // border: Border.all(color: appColor, width: 3),
            image: DecorationImage(
              image: AssetImage(AppImages.img3),
              fit: BoxFit.cover,
            ),
          ),
        ),
        16.height,
        // Name
        Text(
          beauticianName,
          style: AppTextStyles.heading1.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: blackColor,
          ),
        ),
        4.height,
        // Business Name
        Text(
          businessName,
          style: AppTextStyles.regular.copyWith(
            fontSize: 14,
            color: txtdarkgrayColor,
          ),
        ),
        8.height,
        // Rating and Location Row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 15,
                width: 15,
                child: Image.asset(AppImages.starIcon,color: yellowColor,)),
            4.width,
            Text(
              rating.toStringAsFixed(1),
              style: AppTextStyles.subHeading.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: blackColor,
              ),
            ),
            4.width,
            Text(
              '($totalReviews Reviews)',
              style: AppTextStyles.light.copyWith(
                fontSize: 12,
                color: txtdarkgrayColor,
              ),
            ),
            12.width,
            Image.asset(
              AppImages.locationIcon,
              width: 16,
              height: 16,
              color: blackColor,
            ),
            4.width,
            Text(
              location,
              style: AppTextStyles.light.copyWith(
                fontSize: 12,
                color: txtdarkgrayColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

