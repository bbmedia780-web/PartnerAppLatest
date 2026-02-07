import 'package:get/get.dart';
import '../../../../../constarits/images.dart';
import '../../../../../routes/app_routes.dart';

class BeauticianPortfolioController extends GetxController {
  // Beautician List Data
  final RxList<Map<String, dynamic>> beauticianList = [
    {
      'id': '1',
      'name': 'Riya Joshi',
      'image': AppImages.img3,
      'description': 'With 10+ years of experience in the beauty industry, I specialize in bridal makeup, advanced skincare, and latest-focused hairstyling. My goal is to provide personalized beauty solutions using high-quality products and hygienic practices.',
    },
    {
      'id': '2',
      'name': 'Priya Patel',
      'image': AppImages.img1,
      'description': 'Professional makeup artist specializing in bridal and special event makeup. Expert in color matching and skin care preparation.',
    },
    {
      'id': '3',
      'name': 'Aarti Mehta',
      'image': AppImages.img2,
      'description': 'Experienced beautician with expertise in facials, hair styling, and nail art. Committed to making you look and feel your best.',
    },
  ].obs;

  final RxString beauticianName = 'Riya Joshi'.obs;
  final RxString businessName = 'Meera Parlour'.obs;
  final RxDouble rating = 4.8.obs;
  final RxInt totalReviews = 1120.obs;
  final RxString location = 'Surat, India'.obs;
  final RxString aboutMe = 'With 10+ years of experience in the beauty industry, I specialist in bridal makeup, advanced skincare, and latest-focused hairstyling. My goal is to provide personalized beauty solutions using high-quality products and hygienic practices.'.obs;

  void onAddBeautician() {
    Get.toNamed(AppRoutes.addPortfolio);
  }

  void onEditBeautician(String beauticianId) {
    // Navigate to add portfolio screen for editing
    Get.toNamed(AppRoutes.addPortfolio);
  }

  void onBeauticianTap(String beauticianId) {
    // Navigate to beautician details screen
    Get.toNamed(AppRoutes.beauticianDetails, arguments: beauticianId);
  }

  final RxList<Map<String, dynamic>> services = [
    {'name': 'Bridal Wear', 'icon': AppImages.img1},
    {'name': 'Mehandi', 'icon': AppImages.img2},
    {'name': 'Facial', 'icon': AppImages.img3},
    {'name': 'Hair Cutting', 'icon': AppImages.img4},
  ].obs;

  final RxInt selectedServiceIndex = 0.obs;

  void selectService(int index) {
    selectedServiceIndex.value = index;
  }

  final RxList<String> portfolioImages = [
    AppImages.faceImage,
    AppImages.faceImage,
    AppImages.faceImage,
    AppImages.faceImage,
    AppImages.faceImage,
    AppImages.faceImage,
  ].obs;

  final RxList<String> categories = ['All', 'Bridal', 'Facial', 'Hair'].obs;
  final RxString selectedCategory = 'All'.obs;

  final RxList<Map<String, dynamic>> servicesAndRates = [
    {'service': 'Bridal Makeup', 'price': '5000'},
    {'service': 'Facial Treatments', 'price': '2000'},
    {'service': 'Hair cutting', 'price': '500'},
  ].obs;

  final RxMap<int, int> ratingDistribution = {
    5: 2823,
    4: 38,
    3: 4,
    2: 0,
    1: 0,
  }.obs;

  final RxList<Map<String, dynamic>> reviews = [
    {
      'userName': 'Sophia M',
      'userImage': AppImages.img3,
      'timeAgo': '2 days ago',
      'rating': 5,
      'reviewText': 'Amazing makeup artist! emma made me look perfect on my wedding day!',
    },
    {
      'userName': 'Sophia M',
      'userImage': AppImages.img3,
      'timeAgo': '2 days ago',
      'rating': 5,
      'reviewText': 'Amazing makeup artist! emma made me look perfect on my wedding day!',
    },
    {
      'userName': 'Sophia M',
      'userImage': AppImages.img3,
      'timeAgo': '2 days ago',
      'rating': 5,
      'reviewText': 'Amazing makeup artist! emma made me look perfect on my wedding day!',
    },
  ].obs;

  void onCategoryChanged(String? value) {
    if (value != null) {
      selectedCategory.value = value;
    }
  }

  void onSeeAllServices() {
    // Navigate to services screen
  }
}

