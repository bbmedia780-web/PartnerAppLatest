import '../../utils/library_utils.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.title,
      required this.onTap,
      required this.isDisable,
        this.bgColor,
      this.isOutLineBorder = false,
      this.radius = 8.0,
      this.titleSize = 16,
      this.titleColor,
      this.height,
      this.width,
      this.isBoldTitle = true});

  final void Function()? onTap;
  final String title;
  final bool isDisable;
  final bool isOutLineBorder;
  final bool isBoldTitle;
  final double radius;
  final double? height;
  final double? width;
  final double titleSize;
  final Color? bgColor;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height??50,
        width: width,
        decoration: BoxDecoration(
            border: isOutLineBorder ? Border.all(color: appBlack) : null,
            color: isOutLineBorder
                ? Colors.transparent
                : isDisable
                    ? dividerColor
                    : bgColor??appColor,
            borderRadius: BorderRadius.circular(radius)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                      fontSize: titleSize,
                      fontWeight: !isBoldTitle ? FontWeight.w400 : FontWeight.w700,
                      color:titleColor ?? (isOutLineBorder ? appBlack : appWhite)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
