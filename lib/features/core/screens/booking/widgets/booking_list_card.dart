import '../../../../../../utils/library_utils.dart';

class BookingListCard extends StatelessWidget {
  final BookingModel booking;

  const BookingListCard({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookingController>();
    
    return CustomContainer(

      child: Row(
        children: [
          // Profile Image
          Container(
            width: 60,
            height: 60,
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
                ? Icon(Icons.person, color: kColorGray, size: 35)
                : null,
          ),
          12.width,
          // Service Info
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
                  style: AppTextStyles.regular.copyWith(
                    fontSize: 12,
                    color: txtdarkgrayColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                4.height,
                Text(
                  booking.price,
                  style: AppTextStyles.subHeading.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: appColor,
                  ),
                ),
              ],
            ),
          ),
          // Call Now Button
          CustomButton(
            title: 'Call Now',
            onTap: () => controller.callServiceProvider(''),
            isDisable: false,
            bgColor: appColor.withValues(alpha:0.1),
            titleSize: 12,
            titleColor: appColor,
            height: 36,
            width: 90,
          ),
        ],
      ),
    );
  }
}

