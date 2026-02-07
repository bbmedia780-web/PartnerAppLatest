import '../../../../../../utils/library_utils.dart';

class AddReviewScreen extends StatefulWidget {
  const AddReviewScreen({super.key});

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  int selectedRating = 0;
  final TextEditingController reviewController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ReviewController>()) {
      ReviewBinding().dependencies();
    }
    final controller = Get.find<ReviewController>();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: const CustomAppBar(
        title: 'Write Review',
        isBack: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rate your experience',
                  style: AppTextStyles.subHeading.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: blackColor,
                  ),
                ),
                16.height,
                // Star Rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final starValue = index + 1;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedRating = starValue;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          starValue <= selectedRating
                              ? Icons.star
                              : Icons.star_border,
                          color: starValue <= selectedRating
                              ? appColor
                              : kColorGray,
                          size: 40,
                        ),
                      ),
                    );
                  }),
                ),
                32.height,
                Text(
                  'Write your review',
                  style: AppTextStyles.subHeading.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: blackColor,
                  ),
                ),
                12.height,
                CustomTextField(
                  labelName: '',
                  controller: reviewController,
                  hintText: 'Share your experience...',
                  maxLine: 6,
                  textInputType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  validator: (value) => Validators().requiredField(value),
                ),
                32.height,
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
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
            title: 'Submit Review',
            onTap: () {
              if (selectedRating == 0) {
                ShowToast.error('Please select a rating');
                return;
              }

              if (formKey.currentState!.validate()) {
                final newReview = ReviewModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  userName: 'You', // Replace with actual user name
                  userImage: AppImages.personProfileIcon,
                  rating: selectedRating,
                  reviewText: reviewController.text.trim(),
                  timeAgo: 'Just now',
                );

                controller.addReview(newReview);
                Get.back();
                ShowToast.success('Your review has been submitted');
              }
            },
            isDisable: false,
          ),
        ),
      ),
    );
  }
}

