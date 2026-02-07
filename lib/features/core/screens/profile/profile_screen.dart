
import '../../../../../../utils/library_utils.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ProfileController>()) {
      ProfileBinding().dependencies();
    }
    final controller = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        top: false,
        left: false,
        right: false,
        bottom: true,
        child: SingleChildScrollView(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => ProfileCardWidget(
                  userName: controller.userName.value,
                  phoneNumber: controller.phoneNumber.value,
                  onEdit: controller.onEditProfile,
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Account settings',
                style: AppTextStyles.subHeading.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: blackColor,
                ),
              ),
            ),
            10.height,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  // AccountSettingsItemWidget(
                  //   icon: Icons.edit,
                  //   title: 'Edit profile',
                  //   description: 'Update your personal information',
                  //   onTap: controller.onEditProfile,
                  // ),
                  // 8.height,
                  AccountSettingsItemWidget(
                    iconPath: AppImages.businessIcon,
                    title: 'Business information',
                    description: 'Manage your business details',
                    onTap: controller.onBusinessInformation,
                  ),
                  8.height,
                  AccountSettingsItemWidget(
                    iconPath: AppImages.serviceIcon,
                    title: 'Service',
                    description: 'Manage your services',
                    onTap: controller.onService,
                  ),
                  8.height,
                  AccountSettingsItemWidget(
                    iconPath: AppImages.walletIcon,
                    title: 'My Wallet',
                    description: 'Manage your money ',
                    onTap: controller.onWallet,
                  ),
                  8.height,
                  AccountSettingsItemWidget(
                    iconPath: AppImages.notificationIconProfile,
                    title: 'Notification',
                    description: 'Manage notification preferences',
                    onTap: controller.onNotification,
                  ),
                  8.height,
                  AccountSettingsItemWidget(
                    iconPath: AppImages.paymentHistoryIcon,
                    title: 'Payment History',
                    description: 'Your complete payment record',
                    onTap: controller.onPaymentHistory,
                  ),
                  8.height,
                  AccountSettingsItemWidget(
                    iconPath: AppImages.earnCashIcon,
                    title: 'Refer and Earn',
                    description: 'Earn rewards by referring friends',
                    onTap: controller.onReferEarn,
                  ),
                  8.height,
                  AccountSettingsItemWidget(
                    iconPath: AppImages.parlorToolsIcon,
                    title: 'Beautician Portfolio',
                    description: 'Create or update your portfolio',
                    onTap: controller.onBeauticianPortfolio,
                  ),
                  8.height,
                  // AccountSettingsItemWidget(
                  //   iconPath: AppImages.helpSupportIconProfile,
                  //   title: 'Help & support',
                  //   description: 'Get help or contact support',
                  //   onTap: controller.onHelpSupport,
                  // ),
                  // 8.height,
                ],
              ),
            ),
            20.height,
          ],
        ),
          ),
        ),
    );
  }
}

