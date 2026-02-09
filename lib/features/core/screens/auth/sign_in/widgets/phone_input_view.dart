import '../../../../../../utils/library_utils.dart';

class PhoneInputView extends StatelessWidget {
  const PhoneInputView({super.key, required this.controller});
  final SignInController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Get Started',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: blackColor,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Enter a mobile number to login',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: kColorGray,
                        fontWeight: FontWeight.w400,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              // color: kColorGray.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: borderGreyColor.withValues(alpha: 0.5),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Row(
              children: [
                8.width,
                Text(
                  '+91',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: blackColor,
                  ),
                ),
                8.width,
                Expanded(
                  child: CustomTextField(
                    labelName: '',
                    controller: controller.mobileNoController,
                    textInputType: TextInputType.phone,
                    maxLength: 10,
                    showBorder: false,
                    filled: false,
                    counterText: '',
                    textInputAction: TextInputAction.done,
                    textStyle: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: blackColor,
                    ),
                    hintText: 'Mobile Number',
                    hintTextStyle: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: kColorGray,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    onChange: (value) {
                      if (value.length == 10) {
                        // Auto validate and proceed if valid
                        if (controller.validatePhoneNumber()) {
                          FocusScope.of(context).unfocus();
                        }
                      }
                    },
                    onComplete: (){
                      if (controller.validatePhoneNumber()) {
                        controller.onOtpViewChanged(true);
                        controller.maskedPhoneNumber.value =
                            controller.getMaskedPhoneNumber();
                      }
                    },

                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
