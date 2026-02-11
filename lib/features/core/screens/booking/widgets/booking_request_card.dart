import '../../../../../../utils/library_utils.dart';
class BookingRequestCard extends StatelessWidget {
  final BookingModel booking;

  /// height is controlled by parent
  final double height;

  const BookingRequestCard({
    super.key,
    required this.booking,
    this.height = 230, // ✅ default safe height
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookingController>();

    return SizedBox(
      height: height,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderGreyColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// IMAGE
            Container(
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: borderGreyColor,
                image: booking.serviceProviderImage.isNotEmpty
                    ? DecorationImage(
                  image: AssetImage(booking.serviceProviderImage),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
              child: booking.serviceProviderImage.isEmpty
                  ? const Icon(Icons.image_outlined,
                  color: Colors.grey, size: 30)
                  : null,
            ),

            const SizedBox(height: 8),

            Text(
              booking.serviceProviderName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.subHeading.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              '${booking.serviceName} | ${booking.serviceType}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.regular.copyWith(
                fontSize: 12,
                color: txtdarkgrayColor,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              booking.price,
              style: AppTextStyles.subHeading.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: appColor,
              ),
            ),

            const Spacer(),

            Row(
              children: [
                Expanded(
                  child: acceptRejectButton(
                    title: 'Decline',
                    titleColor: errorColor,
                    onTap: () => controller.declineBooking(booking.id),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: acceptRejectButton(
                    title: 'Approve',
                    titleColor: successColor,
                    onTap: () => controller.approveBooking(booking.id),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget acceptRejectButton({
    required String title,
    required Function() onTap,
    required Color titleColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: titleColor.withValues(alpha:0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: titleColor,
            ),
          ),
        ),
      ),
    );
  }
}


