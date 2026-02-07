import '../../../../../../utils/library_utils.dart';

class OutletTypeSelection extends GetView<OnBoardingController> {
  const OutletTypeSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: CustomAppBar(title: "Select your business type"),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Obx(
          () {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Choose your outlet type",
                  style: AppTextStyles.heading2.copyWith(
                    fontSize: 18,
                  ),
                ),
                2.height,
                Container(height: 4,
                  width: 80,
                  decoration: BoxDecoration(
                      color: appColor,
                      borderRadius: BorderRadius.circular(10)),),
                25.height,
                Text(
                  "Pick the option that best matches your business to unlock tailored features.",
                  style: AppTextStyles.regular.copyWith(
                    fontSize: 12,
                    color: kColorGray,
                  ),
                ),
                20.height,
                _optionCard(
                  context,
                  title: "Parlour",
                  description:
                  "Beauty parlour with hair, makeup, and skincare service",
                  icon: Icons.content_cut,
                  isSelected: controller.isSelected("Parlour"),
                  onTap: () {
                    controller.selectOutlet("Parlour");
                  },
                ),

                16.height,

                /// Boutique
                _optionCard(
                  context,
                  title: "Boutique",
                  description: "Fashion boutique with clothing and accessories",
                  icon: Icons.storefront_outlined,
                  isSelected: controller.isSelected("Boutique"),
                  onTap: () {
                    controller.selectOutlet("Boutique");
                  },
                ),
              ],
            );
          }
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
        child: Obx(() => SafeArea(
          child: SizedBox(
            height: 50,
            child: CustomButton(
              title: controller.selectedOutletType.value==null
                  ? "Choose an option to continue"
                  : "Continue",
              isDisable: controller.selectedOutletType.value==null,
              onTap: () async{
                Get.back(result: controller.selectedOutletType.value);
              },
            ),
          ),
        )),
      ),
    );
  }
  Widget _optionCard(
      BuildContext context, {
        required String title,
        required String description,
        required IconData icon,
        required VoidCallback onTap,
        required bool isSelected,
      }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? appColor.withOpacity(0.15) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? appColor : kColorGray.withOpacity(0.4),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? appColor : kColorGray, size: 25),
            12.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: AppTextStyles.regular.copyWith(
                        color: isSelected ? appColor : Colors.black,
                      )),
                  4.height,
                  Text(description,
                      style: AppTextStyles.regular.copyWith(
                        fontSize: 12,
                        color: kColorGray,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
