
import '../../../../../utils/library_utils.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onBack;
  final bool? isBack;
  final List<Widget>? children;
  const CustomAppBar({
    Key? key,
    required this.title,
    this.isBack,
    this.subtitle = "",
    this.onBack,
    this.children
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      bottom: PreferredSize(preferredSize: preferredSize, child: Container(
        width: Get.width,
        height: 2.5,
        color: borderGreyColor,
      )),
      automaticallyImplyLeading: false,
      backgroundColor:appColor,

      leading: isBack==true ? null : GestureDetector(
        onTap: onBack ?? () => Get.back(),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: whiteColor,
          size: 18,
        ),
      ),
      title: Text(
        title,
        style:  AppTextStyles.subHeading.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: whiteColor,
        ),
      ),
      actions: children,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
