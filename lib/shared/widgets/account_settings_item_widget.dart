import '../../../../../utils/library_utils.dart';
class AccountSettingsItemWidget extends StatelessWidget {
  final String? iconPath;
  final IconData? icon;
  final String title;
  final String description;
  final VoidCallback? onTap;

  const AccountSettingsItemWidget({
    super.key,
    this.iconPath,
    this.icon,
    required this.title,
    required this.description,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomContainer(
        // margin: const EdgeInsets.only(bottom: 8),
        // padding: const EdgeInsets.all(16),
        // decoration: BoxDecoration(
        //   color: whiteColor,
        //   borderRadius: BorderRadius.circular(12),
        //   border: Border.all(
        //     color: borderGreyColor,
        //     width: 1,
        //   ),
        // ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: appColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: iconPath != null
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          iconPath!,
                          width: 20,
                          height: 20,
                          color: tealColor,
                        ),
                      )
                    : Icon(
                        icon,
                        color: tealColor,
                        size: 20,
                      ),
              ),
              8.width,
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
                    4.height,
                    Text(
                      description,
                      style: AppTextStyles.light.copyWith(
                        fontSize: 10,
                        color: txtdarkgrayColor,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: txtdarkgrayColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

