import '../../../../../../utils/library_utils.dart';
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();
    controller.onInit();
    // Initialize HomeBinding if not already initialized
    if (!Get.isRegistered<HomeController>()) {
      HomeBinding().dependencies();
    }
    
    // Initialize ProfileBinding if not already initialized
    if (!Get.isRegistered<ProfileController>()) {
      ProfileBinding().dependencies();
    }
    
    // Initialize ReelsBinding if not already initialized
    if (!Get.isRegistered<ReelsController>()) {
      ReelsBinding().dependencies();
    }
    if (!Get.isRegistered<BookingController>()) {
      BookingBinding().dependencies();
    }
    
    final List<Widget> screens = [
      const HomeScreen(isFromDashboard: true),
      const BookingListScreen(),
      const ReelsScreen(isFromDashboard: true),
      const ProfileScreen(),
    ];

    return Obx(
       () {
        return Scaffold(
          appBar: controller.currentIndex.value==2?null:CustomAppBar(
            title:controller.currentIndex.value==0?"Parlour":controller.currentIndex.value==1?"Booking": "Profile",isBack: true,children: [
            Row(children: [
                        IconButton(
                          icon: Image.asset(
                            AppImages.addIcon,
                            width: 20,
                            height: 20,
                            fit: BoxFit.contain,
                            color: whiteColor,
                          ),
                          onPressed: () async{
                            Get.delete<CreateReelsController>();
                            await TrimmedMusicDB.clearStoredTrimmedMusic();
                            Get.toNamed(AppRoutes.createReels);
                          },
                        ),
                        Stack(
                          children: [
                            IconButton(
                              icon: Image.asset(
                                AppImages.notificationBellIcon,
                                width: 24,
                                height: 24,
                                fit: BoxFit.contain,
                                color: whiteColor,
                              ),
                              onPressed: () {
                                Get.toNamed(AppRoutes.notifications);
                              },
                            ),
                            // Positioned(
                            //   right: 12,
                            //   top: 12,
                            //   child: Container(
                            //     width: 8,
                            //     height: 8,
                            //     decoration: const BoxDecoration(
                            //       color: appColor,
                            //       shape: BoxShape.circle,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        ],)
          ],),
          body: SafeArea(
            top: false,
            left: false,
            right: false,
            bottom: true,
            child: Obx(() => screens[controller.currentIndex.value]),
          ),
          bottomNavigationBar: Obx(() => _buildBottomNavigationBar(controller)),
        );
      }
    );
  }

  Widget _buildBottomNavigationBar(DashboardController controller) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: SafeArea(
          top: false,
          child: BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changeIndex,
            type: BottomNavigationBarType.fixed,
            backgroundColor: whiteColor,
            elevation: 0, // IMPORTANT

            selectedItemColor: tealColor,
            unselectedItemColor: txtdarkgrayColor,
            selectedIconTheme: IconThemeData(color: appColor),

            selectedLabelStyle: AppTextStyles.light.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            unselectedLabelStyle: AppTextStyles.light.copyWith(
              fontSize: 12,
            ),

            items: [
              _bottomItem(
                label: 'Home',
                activeIcon: AppImages.homeIcon,
                inactiveIcon: AppImages.homeUnfillIcon,
              ),
              _bottomItem(
                label: 'Booking',
                activeIcon: AppImages.bookingFillIcon,
                inactiveIcon: AppImages.bookingUnfillIcon,
              ),
              _bottomItem(
                label: 'Reels',
                activeIcon: AppImages.reelsFillIcon,
                inactiveIcon: AppImages.reelsIcon,
              ),
              _bottomItem(
                label: 'Profile',
                activeIcon: AppImages.profileFillIcons,
                inactiveIcon: AppImages.profileIcon,
              ),
            ],
          ),
        ),
      ),
    );
  }
  BottomNavigationBarItem _bottomItem({
    required String label,
    required String activeIcon,
    required String inactiveIcon,
  }) {
    return BottomNavigationBarItem(
      label: label,
      icon: Image.asset(
        inactiveIcon,
        width: 24,
        height: 24,
        color: kColorGray,
      ),
      activeIcon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 2,
            width: 28,
            decoration: BoxDecoration(
              color: tealColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 6),
          Image.asset(
            activeIcon,
            width: 24,
            height: 24,
            color: appColor,
          ),
        ],
      ),
    );
  }


}

