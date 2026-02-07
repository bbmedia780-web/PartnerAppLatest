import '../../../../../../utils/library_utils.dart';

class BeauticianListCard extends StatelessWidget {
  final String beauticianName;
  final String imagePath;
  final String description;
  final VoidCallback onEdit;
  final VoidCallback onTap;

  const BeauticianListCard({
    super.key,
    required this.beauticianName,
    required this.imagePath,
    required this.description,
    required this.onEdit,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      radius: 12,
      child: InkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Circle Image
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            12.width,
            // Name and Description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    beauticianName,
                    style: AppTextStyles.subHeading.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: blackColor,
                    ),
                  ),
                  4.height,
                  Text(
                    description,
                    style: AppTextStyles.regular.copyWith(
                      fontSize: 12,
                      color: greyDarkLight,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            12.width,
            // Edit Button
            GestureDetector(
              onTap: onEdit,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: appColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Edit',
                  style: AppTextStyles.regular.copyWith(
                    fontSize: 12,
                    color: whiteColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

