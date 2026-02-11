import '../../../utils/library_utils.dart';
class AppPages {
  static final List<GetPage> pages = [
    GetPage(
        name: AppRoutes.splash,
        page: () => const SplashScreen(),
        binding: SplashBindings()),

    GetPage(
      name: AppRoutes.signIn,
      page: () => const SignInScreen(),
      binding: SignInBinding(),
    ),
    GetPage(
      name: AppRoutes.signUp,
      page: () => const SignUpScreen(),
      binding: SignUpBinding(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnBoardingScreen(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: AppRoutes.serviceMenu,
      page: () => ServiceMenuScreen(),
      binding: ServiceMenuBinding(),
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardScreen(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.reels,
      page: () => const ReelsScreen(),
      binding: ReelsBinding(),
    ),
    GetPage(
      name: AppRoutes.comments,
      page: () => const CommentsScreen(),
      binding: CommentsBinding(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.appPromotion,
      page: () => const AppPromotionScreen(),
      binding: AppPromotionBinding(),
    ),
    GetPage(
      name: AppRoutes.outletTypeSelection,
      page: () =>  OutletTypeSelection(),
      binding: OnboardingBinding(),
    ),
      GetPage(
            name: AppRoutes.notifications,
            page: () =>  NotificationsScreen(),
            binding: NotificationBinding(),
          ),
     GetPage(
            name: AppRoutes.editProfile,
            page: () =>  EditProfileScreen(),
            binding: ProfileBinding(),
          ),
    GetPage(
      name: AppRoutes.kycVerification,
      page: () => const KycVerificationScreen(),
      binding: KycVerificationBinding(),
    ),

    GetPage(
      name: AppRoutes.bookingList,
      page: () => const BookingListScreen(),
      binding: BookingBinding(),
    ),
GetPage(
      name: AppRoutes.bookingRequest,
      page: () => const BookingRequestScreen(),
      binding: BookingBinding(),
    ),
GetPage(
      name: AppRoutes.bookingStatus,
      page: () => const BookingTabScreen(),
      binding: BookingBinding(),
    ),
    GetPage(
      name: AppRoutes.paymentHistory,
      page: () => const PaymentHistoryScreen(),
      binding: PaymentBinding(),
    ),
    GetPage(
      name: AppRoutes.serviceList,
      page: () => const ServiceListScreen(),
      binding: ServiceBinding(),
    ),
    GetPage(
      name: AppRoutes.serviceDetails,
      page: () => const ServiceDetailsScreen(),
    ),
    GetPage(
      name: AppRoutes.outletInformation,
      page: () => const OutletInformationView(),
      binding: OnboardingBinding()
    ),
    GetPage(
      name: AppRoutes.reviewList,
      page: () => const ReviewListScreen(),
      binding: ReviewBinding(),
    ),
    GetPage(
      name: AppRoutes.addReview,
      page: () => const AddReviewScreen(),
      binding: ReviewBinding(),
    ),
    GetPage(
      name: AppRoutes.referEarn,
      page: () => const ReferEarnScreen(),
      binding: ReferEarnBinding(),
    ),
    GetPage(
      name: AppRoutes.beauticianPortfolio,
      page: () => const BeauticianPortfolioScreen(),
      binding: BeauticianPortfolioBinding(),
    ),
    GetPage(
      name: AppRoutes.beauticianDetails,
      page: () {
        final beauticianId = Get.arguments as String? ?? '';
        return BeauticianDetailsScreen(beauticianId: beauticianId);
      },
      binding: BeauticianPortfolioBinding(),
    ),
    GetPage(
      name: AppRoutes.addPortfolio,
      page: () => const AddPortfolioScreen(),
      binding: AddPortfolioBinding(),
    ),
    GetPage(
      name: AppRoutes.beauticianList,
      binding: BeauticianPortfolioBinding(),
      page: () => const BeauticianListScreen(),
    ),
    GetPage(
      name: AppRoutes.wallet,
      page: () => const WalletScreen(),
      binding: WalletBinding(),
    ),
    GetPage(
      name: AppRoutes.createReels,
      page: () => const CreateReelsScreen(),
      binding: CreateReelsBinding(),
    ),


  ];
}
