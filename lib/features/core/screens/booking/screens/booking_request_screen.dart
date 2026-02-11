import '../widgets/booking_request_card.dart';
import '../../../../../shared/widgets/date_selector_field.dart';
import '../../../../../../utils/library_utils.dart';

class BookingRequestScreen extends StatelessWidget {
  const BookingRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookingController>();
    final bool tablet = isTablet(context);

    return Scaffold(
      backgroundColor: bgColor,
      appBar:  CustomAppBar(
        title: 'Bookings Request',
        isBack: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Date Selector
            Padding(
              padding: const EdgeInsets.all(12),
              child: Obx(() => DateSelectorField(
                    selectedDate: controller.selectedDate.value,
                    onDateSelected: (date) {
                      controller.selectedDate.value = date;
                    },
                  )),
            ),
            // Booking Requests Grid
            Expanded(
              child: Obx(() {
                if (controller.requestBookings.isEmpty) {
                  return Center(
                    child: Text(
                      'No booking requests',
                      style: AppTextStyles.regular.copyWith(
                        color: txtdarkgrayColor,
                      ),
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: tablet ? 3 : 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    mainAxisExtent: 230,
                  ),
                  itemCount: controller.requestBookings.length,
                  itemBuilder: (context, index) {
                    return BookingRequestCard(
                      booking: controller.requestBookings[index],
                      height: 230,
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
double getGridRatio(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width <= 380) return 0.75;
  if (width <= 500) return 0.80;
  if (width <= 600) return 1.1;
  if (width <= 900) return 1.2;
  if (width <= 1600) return 1.2;
  return 0.82;
}