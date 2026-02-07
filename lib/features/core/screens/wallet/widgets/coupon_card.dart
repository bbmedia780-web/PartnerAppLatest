import '../../../../../../utils/library_utils.dart';

class CouponCutoutCard extends StatelessWidget {
  final String discount;
  final String description;
  final Color bgColor;
  final Map<String,dynamic> coupon;
  final Color sideColor;
  const CouponCutoutCard({
    super.key,
    required this.discount,
    required this.description,
    required this.bgColor,
    required this.coupon,
    required this.sideColor,

  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ClipPath(
        clipper: TicketClipper(),
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              // LEFT STRIP
              Container(
                width: 44,
                decoration: BoxDecoration(
                  color: sideColor,
                ),
                child: Center(
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: Text(
                      'DISCOUNT',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 1.3,
                      ),
                    ),
                  ),
                ),
              ),

              // CONTENT
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            coupon['code'],
                            style: AppTextStyles.subHeading.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: sideColor,
                            ),
                          ),

                        ],
                      ),
                      5.height,
                      Text(
                        coupon['description'],
                        style: AppTextStyles.light.copyWith(
                          fontSize: 12,
                          color: sideColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      6.height,
                      Text(
                        coupon['type'] == 'flat'
                            ? '₹${coupon['discount']}'
                            : '${coupon['discount']}%',
                        style: AppTextStyles.subHeading.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: sideColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class _ActionButton extends StatelessWidget {
  final String text;

  const _ActionButton({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const cutRadius = 14.0;

    Path path = Path();

    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height / 2 - cutRadius);
    path.arcToPoint(
      Offset(size.width, size.height / 2 + cutRadius),
      radius: const Radius.circular(cutRadius),
      clockwise: false,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, size.height / 2 + cutRadius);
    path.arcToPoint(
      Offset(0, size.height / 2 - cutRadius),
      radius: const Radius.circular(cutRadius),
      clockwise: false,
    );
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
