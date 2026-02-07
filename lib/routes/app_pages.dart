
import 'package:varnika_app/features/core/screens/beautician_portfolio/screens/beautician_list_screen.dart';
import 'package:varnika_app/features/core/screens/booking/logic/booking_binding.dart';
import 'package:varnika_app/features/core/screens/booking/screens/booking_list_screen.dart';
import 'package:varnika_app/features/core/screens/booking/screens/booking_request_screen.dart';
import 'package:varnika_app/features/core/screens/booking/screens/booking_tab_screen.dart';
import 'package:varnika_app/features/core/screens/notification/notification_binding.dart';
import 'package:varnika_app/features/core/screens/notification/notification_screen.dart';
import 'package:varnika_app/features/core/screens/onboarding/logic/onboarding_binding.dart';
import 'package:varnika_app/features/core/screens/onboarding/onboarding_screen.dart';
import 'package:varnika_app/features/core/screens/onboarding/outlet_component/outlet_information/outlet_information.dart';
import 'package:varnika_app/features/core/screens/onboarding/outlet_component/outlet_information/outlet_type_selection.dart';
import 'package:varnika_app/features/core/screens/onboarding/outlet_component/service_menu/logic/service_menu_binding.dart';
import 'package:varnika_app/features/core/screens/onboarding/outlet_component/service_menu/service_menu_screen.dart';
import 'package:varnika_app/features/core/screens/dashboard/dashboard_binding.dart';
import 'package:varnika_app/features/core/screens/dashboard/dashboard_screen.dart';
import 'package:varnika_app/features/core/screens/home/home_binding.dart';
import 'package:varnika_app/features/core/screens/home/home_screen.dart';
import 'package:varnika_app/features/core/screens/profile/edit_profile_screen.dart';
import 'package:varnika_app/features/core/screens/profile/profile_binding.dart';
import 'package:varnika_app/features/core/screens/profile/profile_screen.dart';
import 'package:varnika_app/features/core/screens/reels/reels_binding.dart';
import 'package:varnika_app/features/core/screens/reels/reels_screen.dart';
import 'package:varnika_app/features/core/screens/comments/comments_binding.dart';
import 'package:varnika_app/features/core/screens/comments/comments_screen.dart';
import 'package:varnika_app/features/core/screens/app_promotion/app_promotion_binding.dart';
import 'package:varnika_app/features/core/screens/app_promotion/app_promotion_screen.dart';
import 'package:varnika_app/features/core/screens/kyc_verification/kyc_verification_binding.dart';
import 'package:varnika_app/features/core/screens/kyc_verification/kyc_verification_screen.dart';
import 'package:varnika_app/features/core/screens/payment/logic/payment_binding.dart';
import 'package:varnika_app/features/core/screens/payment/payment_history_screen.dart';
import 'package:varnika_app/features/core/screens/service/logic/service_binding.dart';
import 'package:varnika_app/features/core/screens/service/screens/service_list_screen.dart';
import 'package:varnika_app/features/core/screens/service/screens/service_details_screen.dart';
import 'package:varnika_app/features/core/screens/review/logic/review_binding.dart';
import 'package:varnika_app/features/core/screens/review/screens/review_list_screen.dart';
import 'package:varnika_app/features/core/screens/review/screens/add_review_screen.dart';
import 'package:varnika_app/features/core/screens/refer_earn/logic/refer_earn_binding.dart';
import 'package:varnika_app/features/core/screens/refer_earn/screens/refer_earn_screen.dart';
import 'package:varnika_app/features/core/screens/beautician_portfolio/logic/beautician_portfolio_binding.dart';
import 'package:varnika_app/features/core/screens/beautician_portfolio/screens/beautician_portfolio_screen.dart';
import 'package:varnika_app/features/core/screens/beautician_portfolio/screens/beautician_details_screen.dart';
import 'package:varnika_app/features/core/screens/wallet/logic/wallet_binding.dart';
import 'package:varnika_app/features/core/screens/wallet/screens/wallet_screen.dart';

import '../features/core/screens/beautician_portfolio/add_portfolio/logic/add_portfolio_binding.dart';
import '../features/core/screens/beautician_portfolio/add_portfolio/screens/add_portfolio_screen.dart';
import '../features/core/screens/reels/create_reels/logic/create_reels_binding.dart';
import '../features/core/screens/reels/create_reels/screens/create_reels_screen.dart';
import '../utils/library_utils.dart';

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
