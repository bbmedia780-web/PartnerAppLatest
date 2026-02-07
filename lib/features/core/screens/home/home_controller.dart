import '../../../../utils/library_utils.dart';

class HomeController extends GetxController {
  var todaysBookings = 12.obs;
  var totalRevenue = 2438.0.obs;

  // Recent Activity data
  var recentActivities = [
    {
      'type': 'booking',
      'title': 'New booking received',
      'description': 'Customer booked hair cut service',
      'time': '2 min ago',
      'iconPath': AppImages.calendarIcon,
      'color': const Color(0xFFFFB3BA), // Light pink
      'onTap':AppRoutes.bookingRequest
    },
    {
      'type': 'payment',
      'title': 'Payment received',
      'description': '₹500 received for facial service',
      'time': '15 min ago',
      'iconPath': AppImages.cardIcon,
      'color': const Color(0xFFBAFFC9),
      'onTap': AppRoutes.paymentHistory
    },
    {
      'type': 'review',
      'title': 'Review received',
      'description': '5-star review from customer',
      'time': '1 hour ago',
      'iconPath': AppImages.starIcon,
      'color': const Color(0xFFFFD4A3),
      'onTap': AppRoutes.reviewList,
    },
  ].obs;

  // Marketing Tools data
  var marketingTools = [
    {
      'title': 'Store promotion',
      'description': 'Promote your store & reels',
      'iconPath': AppImages.announceIcon,
      'color': const Color(0xFFD4A5FF), // Light purple
    },
    {
      'title': 'Discount coupons',
      'description': 'Create promotional offers',
      'iconPath': AppImages.discountCardIcon,
      'color': const Color(0xFFFFD4A3), // Light orange
    },
  ].obs;

  void onMarketingToolTap(int index) {
    if (index == 0) {
      // Navigate to store promotion
      // Get.toNamed(AppRoutes.appPromotion);
    } else {
      // Navigate to discount coupons
      // Get.toNamed(AppRoutes.appPromotion);
    }
  }
}

