import '../../../../../../utils/library_utils.dart';
class ReviewController extends GetxController {
  final RxList<ReviewModel> reviews = <ReviewModel>[].obs;
  final RxBool isLoading = false.obs;
  final Rx<RatingSummary> ratingSummary = RatingSummary(
    averageRating: 0.0,
    totalReviews: 0,
    ratingDistribution: {},
  ).obs;

  @override
  void onInit() {
    super.onInit();
    _loadReviews();
  }

  void _loadReviews() {
    isLoading.value = true;
    // Simulate API call - Replace with actual API call
    Future.delayed(const Duration(milliseconds: 500), () {
      reviews.value = [
        ReviewModel(
          id: '1',
          userName: 'Courtney Henry',
          userImage: AppImages.personProfileIcon,
          rating: 5,
          reviewText:
              'Consectetur velit qui adipisicing sunt do reprehenderit ad laboreure tempor ullamco exercitation. Ullamco tempor adipisicing et voluptate duis sit esse aliqua.',
          timeAgo: '2 mins ago',
        ),
        ReviewModel(
          id: '2',
          userName: 'Cameron Williamson',
          userImage: AppImages.personProfileIcon,
          rating: 4,
          reviewText:
              'Consectetur velit qui adipisicing sunt do reprehenderit ad laboreure tempor ullamco.',
          timeAgo: '2 mins ago',
        ),
        ReviewModel(
          id: '3',
          userName: 'Jane Cooper',
          userImage: AppImages.personProfileIcon,
          rating: 3,
          reviewText:
              'Ullamco tempor adipisicing et voluptate duis sit esse aliqua esse ex.',
          timeAgo: '2 mins ago',
        ),
        ReviewModel(
          id: '4',
          userName: 'Robert Fox',
          userImage: AppImages.personProfileIcon,
          rating: 5,
          reviewText:
              'Great service and excellent quality. Highly recommended for anyone looking for professional service.',
          timeAgo: '1 hour ago',
        ),
        ReviewModel(
          id: '5',
          userName: 'Leslie Alexander',
          userImage: AppImages.personProfileIcon,
          rating: 4,
          reviewText: 'Good experience overall. Staff was friendly and professional.',
          timeAgo: '3 hours ago',
        ),
      ];

      _calculateRatingSummary();
      isLoading.value = false;
    });
  }

  void _calculateRatingSummary() {
    if (reviews.isEmpty) {
      ratingSummary.value = RatingSummary(
        averageRating: 0.0,
        totalReviews: 0,
        ratingDistribution: {5: 0, 4: 0, 3: 0, 2: 0, 1: 0},
      );
      return;
    }

    final distribution = <int, int>{5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    double totalRating = 0;

    for (var review in reviews) {
      distribution[review.rating] = (distribution[review.rating] ?? 0) + 1;
      totalRating += review.rating;
    }

    ratingSummary.value = RatingSummary(
      averageRating: totalRating / reviews.length,
      totalReviews: reviews.length,
      ratingDistribution: distribution,
    );
  }

  void refreshReviews() {
    _loadReviews();
  }

  void addReview(ReviewModel review) {
    reviews.insert(0, review);
    _calculateRatingSummary();
  }
}

