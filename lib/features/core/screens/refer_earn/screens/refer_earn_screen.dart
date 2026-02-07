import '../../../../../../utils/library_utils.dart';

class ReferEarnScreen extends StatelessWidget {
  const ReferEarnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ReferEarnController>()) {
      ReferEarnBinding().dependencies();
    }
    final controller = Get.find<ReferEarnController>();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: CustomAppBar(
        title: 'Refer & Earn',
        children: [
          IconButton(
            icon: Image.asset(AppImages.searchIcon, width: 20, height: 20),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 250,
                      height: 180,
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          image: AssetImage(AppImages.referralView),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  // Referral Offer Card
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 170,
                      left: 15,
                      right: 15,
                    ),
                    child: ReferralOfferCard(onReferNow: controller.referNow),
                  ),
                ],
              ),

              18.height,
              // How It Works Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: SectionTitleWithDivider(title: 'How It Works'),
              ),
              12.height,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    HowItWorksStep(
                      iconPath: AppImages.linkIcon,
                      title: 'Share Referral Link',
                      description: 'Send your unique link to friends',
                    ),
                    12.height,
                    HowItWorksStep(
                      iconPath: AppImages.phoneIcon,
                      title: 'Friend Signs Up',
                      description: 'Friend registers using your link',
                    ),
                    12.height,
                    HowItWorksStep(
                      iconPath: AppImages.earnCashIcon,
                      title: 'Earn Cashback',
                      description: 'Cashback added to wallet instantly',
                    ),
                  ],
                ),
              ),
              18.height,
              // Referral Link Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: SectionTitleWithDivider(title: 'Referral Link'),
              ),

              12.height,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Obx(
                  () => Row(
                    children: [
                      Expanded(
                        child: CustomContainer(
                          radius: 12,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: appColor.withOpacity(0.5),
                              ),
                              color: appColor.withOpacity(0.05),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    controller.referralLink.value,
                                    style: AppTextStyles.regular.copyWith(
                                      fontSize: 12,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: controller.copyReferralLink,
                                    child: Image.asset(
                                      AppImages.copyFileIcon,
                                      width: 24,
                                      height: 24,
                                      color: appColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      8.width,
                      // Copy Button

                      // Share Button
                      GestureDetector(
                        onTap: controller.shareReferralLink,
                        child: Container(
                          decoration: BoxDecoration(
                            color: appColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.share_outlined,
                                  color: appWhite,
                                  size: 16,
                                ),
                                5.width,
                                Text(
                                  'Share',
                                  style: AppTextStyles.regular.copyWith(
                                    fontSize: 12,
                                    color: whiteColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              24.height,
              // Summary Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Obx(
                  () => Row(
                    children: [
                      ReferralSummaryCard(
                        value:
                            '₹${controller.totalEarned.value.toStringAsFixed(0)}',
                        label: 'Total Earned',
                      ),
                      12.width,
                      ReferralSummaryCard(
                        value:
                            '${controller.successfulReferrals.value} Friends',
                        label: 'Successful Referrals',
                      ),
                      12.width,
                      ReferralSummaryCard(
                        value:
                            '₹${controller.pendingRewards.value.toStringAsFixed(0)}',
                        label: 'Pending Rewards',
                      ),
                    ],
                  ),
                ),
              ),
              18.height,
              // Referral Link Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: SectionTitleWithDivider(title: 'Referral History'),
              ),

              12.height,
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomContainer(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.lstReferralHistory.length,
                    itemBuilder: (context, index) {
                      final item = controller.lstReferralHistory[index];
                      return customCardHistory(item);
                    },
                  ),
                ),
              ),
              24.height,
            ],
          ),
        ),
      ),
    );
  }

  Widget customCardHistory(Map<String, dynamic> item) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage(AppImages.img3),
                  ),
                  10.width,
                  Text(
                    item['name'],
                    style: AppTextStyles.regular.copyWith(fontSize: 14),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  "₹ "+item['amount'],
                  style: AppTextStyles.regular.copyWith(fontSize: 14,color: purpleDarkColor),
                ),
                10.width,
                Container(child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                  child: Text(item['status'],style: AppTextStyles.regular.copyWith(color: whiteColor,fontSize: 10),),
                ),decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),color: statusColor(item['status'])
                ),),
              ],
            )
          ],
        ),
        4.height,
        Divider(thickness: 1,height: 1,color: dividerColor,),
        4.height
      ],
    );
  }
}
