import '../widgets/booking_tab_card.dart';
import '../../../../../../utils/library_utils.dart';

class BookingTabScreen extends StatefulWidget {
  const BookingTabScreen({super.key});

  @override
  State<BookingTabScreen> createState() => _BookingTabScreenState();
}

class _BookingTabScreenState extends State<BookingTabScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookingController>();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: const CustomAppBar(title: 'Bookings', isBack: false),
      body: SafeArea(
        child: Column(
          children: [
            // Tabs
            TabBar(
              indicatorColor: tabController.index==0?appColor:tabController.index==1?successColor:errorColor,
              labelStyle: AppTextStyles.subHeading.copyWith(color:tabController.index==0?appColor:tabController.index==1?successColor:errorColor ,fontSize: 14),
              controller: tabController,
              dividerColor: dividerColor,
              tabs: [
                Tab(text: "Total Booking",),
                Tab(text: "Completed"),
                Tab(text: "Cancelled"),
              ],
            ),

            15.height,

            Expanded(
              child: Obx(() {
                if(tabController.index==1) {
                  return Center(
                    child: Text(
                      'No bookings found',
                      style: AppTextStyles.regular.copyWith(
                        color: txtdarkgrayColor,
                      ),
                    ),
                  );
                } else if (controller.bookings.isEmpty) {
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
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.bookings.length,
                  itemBuilder: (context, index) {
                    return BookingTabCard(
                      booking: controller.bookings[index],
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
