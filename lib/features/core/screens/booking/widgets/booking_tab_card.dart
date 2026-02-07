
import '../../../../../../utils/library_utils.dart';

class BookingTabCard extends StatelessWidget {
  final BookingModel booking;

  const BookingTabCard({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderGreyColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ID and Date
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ID: ${booking.id}',
                  style: AppTextStyles.subHeading.copyWith(
                    fontSize: 12,
                    color: txtdarkgrayColor,
                  ),
                ),
                Text(
                  _formatDate(booking.date),
                  style: AppTextStyles.subHeading.copyWith(
                    fontSize: 12,
                    color: txtdarkgrayColor,
                  ),
                ),
              ],
            ),
          ),
          Divider(thickness: 1,color: dividerColor.withOpacity(0.5),height: 1,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: borderGreyColor,
                    image: booking.serviceProviderImage.isNotEmpty
                        ? DecorationImage(
                            image: AssetImage(booking.serviceProviderImage),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: booking.serviceProviderImage.isEmpty
                      ? Icon(Icons.image_outlined, color: kColorGray, size: 35)
                      : null,
                ),
                12.width,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.serviceProviderName,
                        style: AppTextStyles.subHeading.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: blackColor,
                        ),
                      ),
                      4.height,
                      Text(
                        '${booking.serviceName} | ${booking.serviceType}',
                        style: AppTextStyles.subHeading.copyWith(
                          fontSize: 12,
                          color: txtdarkgrayColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      4.height,
                      Text(
                        booking.price,
                        style: AppTextStyles.heading2.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: appColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }
}

