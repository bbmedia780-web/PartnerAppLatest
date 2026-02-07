import '../../../../../../utils/library_utils.dart';

class ReviewListScreen extends StatelessWidget {
  const ReviewListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ReviewController>()) {
      ReviewBinding().dependencies();
    }
    final controller = Get.find<ReviewController>();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: const CustomAppBar(
        title: 'Review',

      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Over all rating summary',
                        style: AppTextStyles.heading2.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: blackColor,
                        ),
                      ),
                      10.height,
                      // Rating Summary
                      RatingSummaryCard(
                        ratingSummary: controller.ratingSummary.value,
                      ),
                      20.height,
                      // Reviews List
                      ...controller.reviews.map((review) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ReviewCard(review: review),
                        );
                      }),
                    ],
                  ),
                );
              }),
            ),
            // Write Review Button
            SafeArea(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: whiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: CustomButton(
                  title: 'Write Review',
                  onTap: () {
                    Get.toNamed(AppRoutes.addReview);
                  },
                  isDisable: false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

