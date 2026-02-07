import '../../../../../utils/library_utils.dart';

class ProfileCardWidget extends StatelessWidget {
  final String userName;
  final String phoneNumber;
  final VoidCallback? onEdit;

  const ProfileCardWidget({
    super.key,
    required this.userName,
    required this.phoneNumber,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: tealColor,
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [appColor, tealDarkColor]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: whiteColor,width: 1.5),
                color: whiteColor.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: SizedBox(
                height: 25,
                width: 24,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Image.asset(
                    AppImages.personIcon,
                    width: 25,
                    height: 25,
                    color: whiteColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: AppTextStyles.subHeading.copyWith(
                      color: whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    phoneNumber,
                    style: AppTextStyles.regular.copyWith(
                      color: whiteColor.withValues(alpha: 0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onEdit,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    AppImages.editProfileIcons,
                    width: 18,
                    height: 18,
                    color: appColor,
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

