import '../../../../../../utils/library_utils.dart';

class HomeScreen extends StatelessWidget {
  final bool isFromDashboard;
  
  const HomeScreen({super.key, this.isFromDashboard = false});

  @override
  Widget build(BuildContext context) {
    // Initialize controller if not already registered
    if (!Get.isRegistered<HomeController>()) {
      HomeBinding().dependencies();
    }
    final controller = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        top: false,
        left: false,
        right: false,
        bottom: true,
        child: Column(
          children: [
            // Custom App Bar for Dashboard
            // if (isFromDashboard)
            //   Container(
            //     color: whiteColor,
            //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Text(
            //           'Parlour',
            //           style: AppTextStyles.subHeading.copyWith(
            //             fontSize: 18,
            //             fontWeight: FontWeight.bold,
            //             color: blackColor,
            //           ),
            //         ),
            //         Row(
            //           children: [
            //             IconButton(
            //               icon: Image.asset(
            //                 AppImages.addIcon,
            //                 width: 20,
            //                 height: 20,
            //                 fit: BoxFit.contain,
            //               ),
            //               onPressed: () {},
            //             ),
            //             Stack(
            //               children: [
            //                 IconButton(
            //                   icon: Image.asset(
            //                     AppImages.notificationBellIcon,
            //                     width: 20,
            //                     height: 20,
            //                     fit: BoxFit.contain,
            //                   ),
            //                   onPressed: () {},
            //                 ),
            //                 Positioned(
            //                   right: 12,
            //                   top: 12,
            //                   child: Container(
            //                     width: 8,
            //                     height: 8,
            //                     decoration: const BoxDecoration(
            //                       color: Colors.red,
            //                       shape: BoxShape.circle,
            //                     ),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ],
            //         ),
            //       ],
            //     ),
            //   ),
            // Main Content
            Expanded(
              child: _buildContent(controller),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(HomeController controller) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            17.height,
            Text(
              'Welcome Back!',
              style: AppTextStyles.heading1.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: blackColor,
              ),
            ),

            Text(
              'Hello, Owner!',
              style: AppTextStyles.regular.copyWith(
                fontSize: 14,
                color: txtdarkgrayColor,
              ),
            ),
            15.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Quick stats',
                  style: AppTextStyles.subHeading.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: blackColor,
                  ),
                ),
                // Text('View all',style: AppTextStyles.heading2.copyWith(
                //   fontSize: 12,
                //   color: appColor,
                //   fontWeight: FontWeight.w600
                // ),)
              ],
            ),
           10.height,
          Obx(
                () => IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: QuickStatsCard(
                      value: controller.todaysBookings.value.toString(),
                      label: "Today's Bookings",
                      iconPath: AppImages.calendarIcon,
                      valueColor: tealColor,
                      iconBackgroundColor: lightTealColor,
                    ),
                  ),
                  10.width,
                  Expanded(
                    child: QuickStatsCard(
                      value: '₹${controller.totalRevenue.value.toStringAsFixed(0)}',
                      label: 'Total Revenue',
                      iconPath: AppImages.cardIcon,
                      valueColor: successColor,
                      iconBackgroundColor: successColor.withValues(alpha:0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),


          10.height,
            Text(
              'Recent Activity',
              style: AppTextStyles.subHeading.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: blackColor,
              ),
            ),
            10.height,
            Obx(() => Column(
              children: controller.recentActivities.map((activity) {
                final String? route = activity['onTap'] as String?;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () {
                      debugPrint('activity=== $route');

                      if (route != null && route.isNotEmpty) {
                        Get.toNamed(route);
                      }
                    },
                    child: RecentActivityCard(
                      title: activity['title'] as String? ?? '',
                      description: activity['description'] as String? ?? '',
                      time: activity['time'] as String? ?? '',
                      iconPath: activity['iconPath'] as String? ?? '',
                      iconColor: activity['color'] as Color? ?? Colors.grey,
                    ),
                  ),
                );
              }).toList(),
            )),
            10.height,
            Text(
              'Marketing tools',
              style: AppTextStyles.subHeading.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: blackColor,
              ),
            ),
            10.height,
            Obx(() {
              if (controller.marketingTools.isEmpty) {
                return const SizedBox();
              }

              return Column(
                children: List.generate(
                  controller.marketingTools.length,
                      (index) {
                    final tool = controller.marketingTools[index];
                    return MarketingToolCard(
                      title: tool['title'] as String,
                      description: tool['description'] as String,
                      iconPath: tool['iconPath'] as String,
                      iconColor: tool['color'] as Color,
                      onTap: () => controller.onMarketingToolTap(index),
                    );
                  },
                ),
              );
            }),

            15.height
          ],
        ),
      ),
    );
  }
}
