import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import '../../../../../../utils/library_utils.dart';
import '../../../../../../utils/global.dart';

class OtpView extends StatefulWidget {
  const OtpView({super.key, required this.controller});
  final SignInController controller;

  @override
  State<OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {
  final TextEditingController _otpController = TextEditingController();
  bool _isDemoAutofilled = false;

  @override
  void initState() {
    super.initState();
    // Demo autofill: Fill with "123456" after a short delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _demoAutofill();
    });
    
    // Listen to OTP changes
    _otpController.addListener(() {
      widget.controller.onOtpChanged(_otpController.text);
    });
  }

  void _demoAutofill() {
    if (!_isDemoAutofilled && mounted) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted && _otpController.text.isEmpty) {
          _otpController.text = '123456';
          widget.controller.onOtpChanged('123456');
          setState(() {
            _isDemoAutofilled = true;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter OTP',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: blackColor,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 6),
              Obx(() => Text(
                    'Enter OTP sent on number ${widget.controller.maskedPhoneNumber.value}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: kColorGray,
                      fontWeight: FontWeight.w400,
                      height: 1.3,
                    ),
                  )),
            ],
          ),
          32.height,
          Center(
            child: Pinput(
              length: 6,
              controller: _otpController,
              onChanged: (value) {
                widget.controller.onOtpChanged(value);
              },
              onCompleted: (value) {
                widget.controller.onOtpChanged(value);
                // Auto-submit if OTP is valid
                if (widget.controller.validateOtp()) {
                  // Optionally auto-navigate or show success
                }
              },
              autofillHints: const [AutofillHints.oneTimeCode],
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              defaultPinTheme: PinTheme(
                width: 48,
                height: 48,
                textStyle: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: blackColor,
                ),
                decoration: BoxDecoration(
                  color: kColorGray.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: kColorGray.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
              ),
              focusedPinTheme: PinTheme(
                width: 48,
                height: 48,
                textStyle: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: blackColor,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: appColor,
                    width: 1.5,
                  ),
                ),
              ),
              submittedPinTheme: PinTheme(
                width: 48,
                height: 48,
                textStyle: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: blackColor,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: appColor,
                    width: 2,
                  ),
                ),
              ),
              pinAnimationType: PinAnimationType.none,
              hapticFeedbackType: HapticFeedbackType.lightImpact,
              cursor: Container(
                width: 2,
                height: 20,
                decoration: BoxDecoration(
                  color: appColor,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ),
          ),
          24.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  ShowToast.success('A new OTP has been sent to your number');
                },
                child: Text(
                  'Resend',
                  style: GoogleFonts.inter(
                    color: errorColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
