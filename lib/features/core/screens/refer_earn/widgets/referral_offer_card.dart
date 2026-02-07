import '../../../../../../utils/library_utils.dart';

class ReferralOfferCard extends StatelessWidget {
  final VoidCallback onReferNow;

  const ReferralOfferCard({
    super.key,
    required this.onReferNow,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xffFEF3F1),
              Color(0xFFEFE2FB)
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 25,
                            width: 25,
                            child: Image.asset(
                              AppImages.giftIcon,
                            ),
                          ),
                          12.width,
                          Text(
                            'Earn ₹100 Wallet Cashback',
                            style: AppTextStyles.subHeading.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: purpleDarkColor,
                            ),
                          ),
                        ],
                      ),
                      4.height,
                      Text(
                        'For every successful referral',
                        style: AppTextStyles.regular.copyWith(
                          fontSize: 12,
                          color: purpleColor,
                        ),
                      ),
                      2.height,
                      Text(
                        'T&C Apply',
                        style: AppTextStyles.light.copyWith(
                          fontSize: 10,
                          color: purpleColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            16.height,
            Center(
              child: CustomButton(
                height: 40,
                width: Get.width * 0.60,
                title: 'Refer Now',
                onTap: onReferNow,
                isDisable: false,
                bgColor: appColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

