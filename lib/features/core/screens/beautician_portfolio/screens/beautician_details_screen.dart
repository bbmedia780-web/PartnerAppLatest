import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:varnika_app/constarits/colors.dart';
import 'package:varnika_app/constarits/int_extensions.dart';
import 'package:varnika_app/shared/widgets/app_text_style.dart';
import 'package:varnika_app/shared/widgets/custom_appbar.dart';
import 'package:varnika_app/shared/widgets/custom_container.dart';
import '../logic/beautician_portfolio_binding.dart';
import '../logic/beautician_portfolio_controller.dart';
import '../widgets/beautician_profile_section.dart';
import '../widgets/portfolio_grid_item.dart';
import '../widgets/rating_distribution_bar.dart';
import '../widgets/review_card_widget.dart';
import '../widgets/service_icon_item.dart';

class BeauticianDetailsScreen extends StatelessWidget {
  final String beauticianId;
  
  const BeauticianDetailsScreen({
    super.key,
    required this.beauticianId,
  });

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<BeauticianPortfolioController>()) {
      BeauticianPortfolioBinding().dependencies();
    }
    final controller = Get.find<BeauticianPortfolioController>();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: const CustomAppBar(
        title: 'Beautician Portfolio',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Beautician Profile Section
                Obx(() => BeauticianProfileSection(
                      beauticianName: controller.beauticianName.value,
                      businessName: controller.businessName.value,
                      rating: controller.rating.value,
                      totalReviews: controller.totalReviews.value,
                      location: controller.location.value,
                    )),
                24.height,
                // Services Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Services',
                      style: AppTextStyles.subHeading.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: blackColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.onSeeAllServices,
                      child: Text(
                        'See All',
                        style: AppTextStyles.subHeading.copyWith(
                          fontSize: 14,
                          color: appColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                12.height,
                Obx(() => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: controller.services.asMap().entries.map((entry) {
                          final index = entry.key;
                          final service = entry.value;
                          return Padding(
                            padding: const EdgeInsets.only(right: 5, left: 5),
                            child: ServiceIconItem(
                              serviceName: service['name'] as String,
                              imagePath: service['icon'] as String,
                              isSelected: controller.selectedServiceIndex.value == index,
                              onTap: () => controller.selectService(index),
                            ),
                          );
                        }).toList(),
                      ),
                )),
                24.height,
                // About Me Section
                Text(
                  'About Me',
                  style: AppTextStyles.subHeading.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: blackColor,
                  ),
                ),
                12.height,
                Obx(() => Text(
                      controller.aboutMe.value,
                      style: AppTextStyles.regular.copyWith(
                        fontSize: 13,
                        color: blackColor,
                        height: 1.5,
                      ),
                    )),
                24.height,
                // My Portfolio Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My Portfolio',
                      style: AppTextStyles.subHeading.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: blackColor,
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      height: 40,
                      child: Obx(() => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: borderGreyColor),
                            ),
                            child: DropdownButton<String>(
                              value: controller.selectedCategory.value,
                              items: controller.categories.map((category) {
                                return DropdownMenuItem<String>(
                                  value: category,
                                  child: Text(
                                    category,
                                    style: AppTextStyles.regular.copyWith(fontSize: 12),
                                  ),
                                );
                              }).toList(),
                              onChanged: controller.onCategoryChanged,
                              underline: const SizedBox(),
                              isExpanded: true,
                              hint: Text(
                                'Categories',
                                style: AppTextStyles.regular.copyWith(fontSize: 12),
                              ),
                            ),
                          )),
                    ),
                  ],
                ),
                12.height,
                // Portfolio Grid
                Obx(() => GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 1,
                      ),
                      itemCount: controller.portfolioImages.length,
                      itemBuilder: (context, index) {
                        return PortfolioGridItem(
                          imagePath: controller.portfolioImages[index],
                        );
                      },
                    )),
                24.height,
                // Services & Rates Section
                Text(
                  'Services & Rates',
                  style: AppTextStyles.subHeading.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: blackColor,
                  ),
                ),
                12.height,
                Obx(() => Column(
                  children: controller.servicesAndRates.asMap().entries.map((entry) {
                    final service = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: CustomContainer(
                        radius: 12,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  service['service'] as String,
                                  style: AppTextStyles.regular.copyWith(
                                    fontSize: 16,
                                    color: greyDarkLight,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '₹${service['price']}',
                                  style: AppTextStyles.subHeading.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: greyDarkLight,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                )),
                24.height,
                // Rating Distribution
                Text(
                  'Rating Distribution',
                  style: AppTextStyles.subHeading.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: blackColor,
                  ),
                ),
                12.height,
                Obx(() {
                  final maxCount = controller.ratingDistribution.values.reduce((a, b) => a > b ? a : b);
                  return CustomContainer(
                    child: Column(
                      children: [5, 4, 3, 2, 1].map((rating) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12, top: 10),
                          child: RatingDistributionBar(
                            rating: rating,
                            count: controller.ratingDistribution[rating] ?? 0,
                            maxCount: maxCount,
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }),
                24.height,
                // User Reviews Section
                Text(
                  'User Reviews',
                  style: AppTextStyles.subHeading.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: blackColor,
                  ),
                ),
                12.height,
                Obx(() => Column(
                      children: controller.reviews.map((review) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ReviewCardWidget(
                            userName: review['userName'] as String,
                            userImage: review['userImage'] as String,
                            timeAgo: review['timeAgo'] as String,
                            rating: review['rating'] as int,
                            reviewText: review['reviewText'] as String,
                          ),
                        );
                      }).toList(),
                    )),
                24.height,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

