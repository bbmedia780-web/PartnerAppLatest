
import '../../../../../utils/library_utils.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  SignInController signInController = Get.put(SignInController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appWhite,
      body: GetBuilder<SignInController>(
      builder: (controller) {
        return Column(
          children: [
            // Carousel Section with Overlay - Full Width
            SizedBox(
              height: (MediaQuery.of(context).size.height) * 0.35,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Carousel Slider - Full Width
                  CarouselSlider(
                    items: controller.lstImgs
                        .map(
                          (image) => Image.asset(
                            image,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        )
                        .toList(),
                    options: CarouselOptions(
                      onPageChanged: (index, reason) {
                        controller.changePageIndex(index);
                      },
                      height: (MediaQuery.of(context).size.height) * 0.35,
                      viewportFraction: 1.0,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      enableInfiniteScroll: true,
                    ),
                  ),
                  // Black Transparency Overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.3),
                            Colors.black.withValues(alpha: 0.5),
                            Colors.black.withValues(alpha: 0.7),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Text Layer on Top
                  Positioned(
                    left: 16,
                    bottom: 20,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PARTNER WITH BEAUTY HUB!',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Obx(() => Text(
                              controller.isOtpView.value
                                  ? 'Access to tools and support'
                                  : 'Reach customers far away from you',
                              style: GoogleFonts.playfairDisplay(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                height: 1.2,
                              ),
                            )),
                        const SizedBox(height: 16),
                        // Progress Indicator
                        Row(
                          children: List.generate(
                            controller.lstImgs.length,
                            (index) => Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Container(
                                height: 2,
                                width: ((MediaQuery.of(context).size.width) - 70 - (controller.lstImgs.length - 1) * 7) / controller.lstImgs.length,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: controller.pageIndex.value == index
                                      ? Colors.white
                                      : Colors.white.withValues(alpha: 0.4),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Form Section
            Expanded(
              child: SingleChildScrollView(
                child: Obx(
                  () => controller.isOtpView.value
                      ? OtpView(controller: controller)
                      : PhoneInputView(controller: controller),
                ),
              ),
            ),
          ],
        );
      },
      ),
      bottomNavigationBar: SafeArea(
        child: Obx(() {
          return SizedBox(
            height: 100,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Column(
                children: [
                  CustomButton(
                    bgColor: signInController.isOtpView.value ? appColor : null,
                    onTap: () {
                      if (!signInController.isOtpView.value) {
                        if (signInController.validatePhoneNumber()) {
                          signInController.onOtpViewChanged(true);
                          signInController.maskedPhoneNumber.value =
                              signInController.getMaskedPhoneNumber();
                        }
                      } else {
                        if (signInController.validateOtp()) {
                          Get.toNamed(AppRoutes.onboarding);
                        }
                      }
                    },
                    title: "Continue",
                    isDisable: !signInController.isButtonEnable.value,
                  ),
                  15.height,
                  Text(
                    'By logging in, agree to Beauty Hub\'s terms & conditions',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: kColorGray,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
