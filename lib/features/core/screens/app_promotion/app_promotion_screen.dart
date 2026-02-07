import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:varnika_app/constarits/colors.dart';
import 'package:varnika_app/constarits/int_extensions.dart';
import 'package:varnika_app/features/core/screens/app_promotion/app_promotion_binding.dart';
import 'package:varnika_app/features/core/screens/app_promotion/app_promotion_controller.dart';
import 'package:varnika_app/shared/widgets/ad_credit_balance_card.dart';
import 'package:varnika_app/shared/widgets/app_text_style.dart';
import 'package:varnika_app/shared/widgets/create_campaign_modal.dart';
import 'package:varnika_app/shared/widgets/coupon_management_card.dart';
import 'package:varnika_app/shared/widgets/custom_appbar.dart';
import 'package:varnika_app/shared/widgets/promotion_card_widget.dart';
import 'package:varnika_app/shared/widgets/top_up_credits_modal.dart';

class AppPromotionScreen extends StatelessWidget {
  const AppPromotionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AppPromotionController>()) {
      AppPromotionBinding().dependencies();
    }
    final controller = Get.find<AppPromotionController>();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: CustomAppBar(
        title: "App Promotion",
        children: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: whiteColor),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => controller.isCouponView.value
                    ? CouponManagementCard(
                        activeCouponsCount: controller.activeCouponsCount.value,
                        onViewStatus: controller.onViewStatus,
                        onHistory: controller.onViewHistory,
                      )
                    : AdCreditBalanceCard(
                        balance: controller.adCreditBalance.value,
                        onAddCredits: controller.onAddCredits,
                        onHistory: controller.onViewHistory,
                      )),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Active Promotions',
                        style: AppTextStyles.subHeading.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: blackColor,
                        ),
                      ),
                      Row(
                        children: [
                          Obx(() => Text(
                                '${controller.isCouponView.value ? controller.activeCouponsCount.value : controller.activePromotionsCount.value} Active',
                                style: AppTextStyles.light.copyWith(
                                  fontSize: 12,
                                  color: txtdarkgrayColor,
                                ),
                              )),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: controller.onAddPromotion,
                            child: Container(
                              width: 25,
                              height: 25,
                              decoration: const BoxDecoration(
                                color: whiteColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.add,
                                color: blackColor,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                16.height,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Obx(() => controller.isCouponView.value
                      ? _buildCouponPromotions(controller)
                      : _buildAdPromotions(controller)),
                ),
               10.height,
              ],
            ),
          ),
          // Top up credits modal
          Obx(() => controller.showTopUpModal.value
              ? GestureDetector(
                  onTap: controller.closeTopUpModal,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: () {}, // Prevent closing when tapping modal
                        child:  TopUpCreditsModal(),
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink()),
          // Create campaign modal
          Obx(() => controller.showCreateCampaignModal.value
              ? GestureDetector(
                  onTap: controller.closeCreateCampaignModal,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: () {},
                        child: CreateCampaignModal(
                          campaignNameController: controller.campaignNameController,
                          dailyBudgetController: controller.dailyBudgetController,
                          selectedCampaignType: controller.selectedCampaignType.value,
                          selectedDuration: controller.selectedDuration.value,
                          campaignTypes: controller.campaignTypes,
                          durationOptions: controller.durationOptions,
                          onCampaignTypeSelected: controller.selectCampaignType,
                          onDurationSelected: controller.selectDuration,
                          onCreate: controller.createCampaign,
                          onCancel: controller.closeCreateCampaignModal,
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink()),
        ],
      ),
    );
  }

  Widget _buildAdPromotions(AppPromotionController controller) {
    return Column(
      children: [
        PromotionCardWidget(
          title: 'Hair services store',
          subtitle: 'Featured store',
          status: 'Active',
          metrics: {
            'CPC': '₹12.09',
            'Clicks': '1,250',
            'Conv.': '45',
            'Impr.': '8,400',
          },
          budget: 'Budget ₹500/day',
          icon: const Icon(Icons.content_cut, color: tealColor, size: 20),
          onEdit: () => controller.onEditPromotion(0),
          onPush: () => controller.onPushPromotion(0),
        ),
        8.height,
        PromotionCardWidget(
          title: 'Facial reels video',
          subtitle: 'Promoted reel',
          status: 'Active',
          metrics: {
            'CPC': '₹12.09',
            'Clicks': '1,250',
            'Conv.': '45',
            'Impr.': '8,400',
          },
          budget: 'Budget ₹300/day',
          icon: const Icon(Icons.face, color: tealColor, size: 24),
          onEdit: () => controller.onEditPromotion(1),
          onPush: () => controller.onPushPromotion(1),
        ),
      ],
    );
  }

  Widget _buildCouponPromotions(AppPromotionController controller) {
    return Column(
      children: [
        PromotionCardWidget(
          title: 'Welcome50',
          subtitle: 'Welcome offer',
          status: 'Active',
          metrics: {
            'Used': '12',
            'Limit': '100',
            'Savings': '₹2,400',
            'Revenue': '₹8,400',
          },
          budget: 'Min.spend: ₹500',
          icon: Container(
            decoration: BoxDecoration(
              color: successColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child:  Icon(Icons.percent, color: successColor, size: 24),
          ),
          isCoupon: true,
          onEdit: () => controller.onEditPromotion(0),
          onDeactivate: () => controller.onDeactivatePromotion(0),
        ),
        10.height,
        PromotionCardWidget(
          title: 'Hair100',
          subtitle: 'Hair services',
          status: 'Active',
          metrics: {
            'Used': '12',
            'Limit': '100',
            'Savings': '₹200',
            'Revenue': '₹8,400',
          },
          budget: 'Min.spend: ₹2000',
          icon: Container(
            decoration: BoxDecoration(
              color: successColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child:  Icon(Icons.percent, color: successColor, size: 24),
          ),
          isCoupon: true,
          onEdit: () => controller.onEditPromotion(1),
          onDeactivate: () => controller.onDeactivatePromotion(1),
        ),
        PromotionCardWidget(
          title: 'Hair100',
          subtitle: 'Hair services',
          status: 'Active',
          metrics: {
            'Used': '12',
            'Limit': '100',
            'Savings': '₹200',
            'Revenue': '₹8,400',
          },
          budget: 'Min.spend: ₹2000',
          icon: Container(
            decoration: BoxDecoration(
              color: successColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child:  Icon(Icons.percent, color: successColor, size: 24),
          ),
          isCoupon: true,
          onEdit: () => controller.onEditPromotion(2),
          onDeactivate: () => controller.onDeactivatePromotion(2),
        ),
      ],
    );
  }
}
