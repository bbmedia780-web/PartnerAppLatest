import '../../../../../utils/library_utils.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    super.key,
    this.radius,
    this.bgColor,
    required this.child,
     this.borderColor,
    this.isPadding=true
  });
  final double? radius;
  final Color? bgColor;
  final Widget child;
  final bool isPadding;
  final Color? borderColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
        border: Border.all(color:borderColor?? Color(0xFFD0D5DD).withValues(alpha:0.5)),
        color:  whiteColor,
        borderRadius: BorderRadius.circular(radius??16),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFD0D5DD).withValues(alpha:0.1),
            spreadRadius: 0,
            blurRadius: 4,
            offset: Offset(0, 2)
          )
        ]
      ),
      child: Padding(padding:  EdgeInsets.all(isPadding?8.0:0), child: child),
    );
  }
}

Color statusColor(status) {
  String statuss = status.toString().toLowerCase();
  if (statuss == 'inactive' || statuss=="complete") {
    return kColorGray;
  } else if (statuss == 'active') {
    return successColor;
  } else if(statuss=="pending"){
    return yellowColor;
  }
  return whiteColor;
}
