import '../logic/booking_binding.dart';
import '../widgets/booking_list_card.dart';
import '../../../../../shared/widgets/date_selector_field.dart';
import '../widgets/booking_request_card.dart';
import '../../../../../../utils/library_utils.dart';

class BookingListScreen extends StatelessWidget {
  const BookingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<BookingController>()) {
      BookingBinding().dependencies();
    }
    final controller = Get.find<BookingController>();
    final searchController = TextEditingController();
    final bool tablet = isTablet(context);
    final double screenWidth = MediaQuery.of(context).size.width;

    final int visibleCards = tablet ? 3 : 2;
    final double totalSpacing =
        24 + (12 * (visibleCards - 1));

    final double cardWidth =
        (screenWidth - totalSpacing) / visibleCards;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------- Select Date ----------------
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text('Select Date', style: AppTextStyles.subHeading),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Obx(
                () => DateSelectorField(
                  selectedDate: controller.selectedDate.value,
                  onDateSelected: (date) {
                    controller.selectedDate.value = date;
                  },
                ),
              ),
            ),

            // ---------------- Search ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: CustomTextField(
                controller: searchController,
                labelName: '',
                hintText: 'Search here...',
                prefixIcon: SizedBox(
                  height: 20,
                  width: 20,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Image.asset(AppImages.searchIcon, color: kColorGray),
                  ),
                ),
                filled: true,
                fillColor: fillColor,
                showBorder: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                onChange: (value) {},
              ),
            ),

            12.height,

            // ---------------- Booking Requests Title ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Booking Requests', style: AppTextStyles.subHeading),
                  InkWell(
                      onTap: (){
                        Get.toNamed(AppRoutes.bookingRequest);
                      },
                      child: Text('View All', style: AppTextStyles.subHeading.copyWith(color: appColor,fontSize: 12))),

                ],
              ),
            ),

            8.height,

            // ---------------- Horizontal List ----------------
            Obx(() {
              if (controller.requestBookings.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'No booking requests',
                    style: AppTextStyles.regular.copyWith(
                      color: txtdarkgrayColor,
                    ),
                  ),
                );
              }

              return SizedBox(
                height: 230,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: controller.requestBookings.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: SizedBox(
                        width: cardWidth,
                        child: BookingRequestCard(
                          booking: controller.requestBookings[index],
                          height: 230,
                        ),
                      ),
                    );
                  },
                ),
              );

            }),

            12.height,

            Divider(color: dividerColor,thickness: 1,),
            // ---------------- All Bookings Title ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('All Bookings', style: AppTextStyles.subHeading),
                  InkWell(
                      onTap: (){
                        Get.toNamed(AppRoutes.bookingStatus);
                      },
                      child: Text('View All', style: AppTextStyles.subHeading.copyWith(color: appColor,fontSize: 12))),

                ],
              ),
            ),

            8.height,

            // ---------------- Vertical List ----------------
            Expanded(
              child: Obx(() {
                if (controller.bookings.isEmpty) {
                  return Center(
                    child: Text(
                      'No bookings found',
                      style: AppTextStyles.regular.copyWith(
                        color: txtdarkgrayColor,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: controller.bookings.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: BookingListCard(
                        booking: controller.bookings[index],
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
