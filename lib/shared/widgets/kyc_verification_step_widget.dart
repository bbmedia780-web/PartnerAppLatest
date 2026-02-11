import '../../../../../utils/library_utils.dart';

class KycVerificationStepWidget extends StatelessWidget {
  final int stepIndex;
  final KycVerificationController controller;

  const KycVerificationStepWidget({
    super.key,
    required this.stepIndex,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    switch (stepIndex) {
      case 0:
        return _buildAadhaarStep();
      case 1:
        return _buildPanStep();
      case 2:
        return _buildGstStep();
      case 3:
        return _buildBankStep();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildAadhaarStep() {
    return Form(
      key: controller.aadhaarFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Aadhaar Verification',
            style: AppTextStyles.heading2.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: blackColor,
            ),
          ),
          Text(
            'Enter your Aadhaar number and mobile number to receive OTP',
            style: AppTextStyles.light.copyWith(
              fontSize: 12,
              color: txtdarkgrayColor,
            ),
          ),
          24.height,
          CustomTextField(
            textInputType: TextInputType.number,
            hintText: '1234 5678 9012',
            labelName: 'Aadhaar Number',
            controller: controller.aadhaarController,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(12),
            ],
            validator: (value) => Validators().validateAadhaar(value),
          ),
          // 16.height,
          // CustomTextField(
          //   textInputType: TextInputType.number,
          //   hintText: '9876543210',
          //   labelName: 'Mobile Number',
          //   controller: controller.mobileController,
          //   inputFormatters: [
          //     FilteringTextInputFormatter.digitsOnly,
          //     LengthLimitingTextInputFormatter(10),
          //   ],
          //   validator: (value) => Validators().validateMobile(value),
          // ),
          24.height,
          Obx(() => controller.isAadhaarOtpSent.value
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter OTP',
                      style: AppTextStyles.subHeading.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: blackColor,
                      ),
                    ),
                    12.height,
                    Pinput(
                      length: 6,
                      controller: controller.otpController,
                      defaultPinTheme: PinTheme(
                        width: 40,
                        height: 40,
                        textStyle: AppTextStyles.subHeading.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: borderGreyColor),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      focusedPinTheme: PinTheme(
                        width: 40,
                        height: 40,
                        textStyle: AppTextStyles.subHeading.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: tealColor, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onCompleted: (value) {
                        controller.verifyAadhaarOTP();
                      },
                    ),
                    16.height,
                    Row(
                      children: [
                        TextButton(
                          onPressed: controller.isGeneratingAadhaarOtp.value
                              ? null
                              : controller.generateAadhaarOTP,
                          child: Text(
                            'Resend OTP',
                            style: AppTextStyles.regular.copyWith(
                              color: tealColor,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Obx(() => CustomButton(
                              title: controller.isVerifyingAadhaarOtp.value
                                  ? 'Verifying...'
                                  : 'Verify OTP',
                              onTap: controller.isVerifyingAadhaarOtp.value
                                  ? null
                                  : controller.verifyAadhaarOTP,
                              isDisable: controller.isVerifyingAadhaarOtp.value,
                            )),
                      ],
                    ),
                  ],
                )
              : Obx(() => CustomButton(
                    title: controller.isGeneratingAadhaarOtp.value
                        ? 'Sending OTP...'
                        : 'Send OTP',
                    onTap: controller.isGeneratingAadhaarOtp.value
                        ? null
                        : controller.generateAadhaarOTP,
                    isDisable: controller.isGeneratingAadhaarOtp.value,
                  ))),
        ],
      ),
    );
  }

  Widget _buildPanStep() {
    return Form(
      key: controller.panFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PAN Verification',
            style: AppTextStyles.heading2.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: blackColor,
            ),
          ),
          Text(
            'Enter your PAN number for verification',
            style: AppTextStyles.light.copyWith(
              fontSize: 12,
              color: txtdarkgrayColor,
            ),
          ),
          24.height,
          CustomTextField(
            textInputType: TextInputType.text,
            hintText: 'ABCDE1234F',
            labelName: 'PAN Number',
            controller: controller.panController,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
              UpperCaseTextFormatter(),
              LengthLimitingTextInputFormatter(10),
            ],
            validator: (value) => Validators().validatePan(value),
          ),
          24.height,
          Obx(() => CustomButton(
                title: controller.isVerifyingPan.value
                    ? 'Verifying...'
                    : 'Verify PAN',
                onTap: controller.isVerifyingPan.value
                    ? null
                    : controller.verifyPAN,
                isDisable: controller.isVerifyingPan.value,
              )),
        ],
      ),
    );
  }

  Widget _buildGstStep() {
    return Form(
      key: controller.gstFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'GSTIN Verification',
            style: AppTextStyles.heading2.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: blackColor,
            ),
          ),
          Text(
            'Enter your GSTIN number (Optional)',
            style: AppTextStyles.light.copyWith(
              fontSize: 12,
              color: txtdarkgrayColor,
            ),
          ),
          24.height,
          CustomTextField(
            textInputType: TextInputType.text,
            hintText: '22AAAAA0000A1Z5',
            labelName: 'GSTIN Number (Optional)',
            controller: controller.gstinController,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
              UpperCaseTextFormatter(),
              LengthLimitingTextInputFormatter(15),
            ],
            validator: (value) => value?.isEmpty == true
                ? null
                : Validators().validateGSTNo(value),
          ),
          24.height,
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: controller.skipGST,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    side: BorderSide(color: borderGreyColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Skip',
                    style: AppTextStyles.subHeading.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: blackColor,
                    ),
                  ),
                ),
              ),
              12.width,
              Expanded(
                child: Obx(() => CustomButton(
                      title: controller.isVerifyingGst.value
                          ? 'Verifying...'
                          : 'Verify GSTIN',
                      onTap: controller.isVerifyingGst.value
                          ? null
                          : controller.verifyGST,
                      isDisable: controller.isVerifyingGst.value,
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBankStep() {
    return Form(
      key: controller.bankFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bank Account Verification',
            style: AppTextStyles.heading2.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: blackColor,
            ),
          ),
          Text(
            'Enter your bank account details for verification',
            style: AppTextStyles.light.copyWith(
              fontSize: 12,
              color: txtdarkgrayColor,
            ),
          ),
          12.height,
          CustomTextField(
            textInputType: TextInputType.name,
            hintText: 'Account Holder Name',
            labelName: 'Account Holder Name',
            controller: controller.accountNameController,
            validator: (value) => Validators().validateAccountHolder(value),
          ),
          8.height,
          CustomTextField(
            textInputType: TextInputType.number,
            hintText: '123456789012',
            labelName: 'Account Number',
            controller: controller.accountNumberController,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(18),
            ],
            validator: (value) => Validators().validateAccountNumber(value),
          ),
          8.height,
          CustomTextField(
            textInputType: TextInputType.text,
            hintText: 'ABCD0123456',
            labelName: 'IFSC Code',
            controller: controller.ifscController,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
              UpperCaseTextFormatter(),
              LengthLimitingTextInputFormatter(11),
            ],
            validator: (value) => Validators().validateIfsc(value),
          ),
          Obx(() {
            if(controller.verifiedBankDetails.isEmpty){
              return const SizedBox.shrink();
            } else if (controller.verifiedBankDetails['account_status'] == 'VALID') {
              final data = controller.verifiedBankDetails;
              return Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: _buildVerificationSuccessCard(data),
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
          24.height,

          Obx(() => CustomButton(
                title: controller.isVerifyingBank.value
                    ? 'Verifying...'
                    : 'Verify Bank Account',
                onTap: controller.isVerifyingBank.value
                    ? null
                    : controller.verifyBank,
                isDisable: controller.isVerifyingBank.value,
              )),
        ],
      ),
    );
  }
  Widget _buildVerificationSuccessCard(Map<String, dynamic> data) {
    final bankName = data['bank_name'] ?? 'N/A';
    final accountHolderName = data['name_at_bank'] ?? 'N/A';
    final branch = data['ifsc_details']['address'] ?? data['branch'] ?? 'N/A';

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.green.shade50, // Light green background
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.green.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 24),
              12.width,
              Text(
                'Verification Successful!',
                style: AppTextStyles.heading2.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
              ),
            ],
          ),
          12.height,
          _buildDetailRow(
            label: 'Account Holder Name (Verified):',
            value: accountHolderName,
            icon: Icons.person,
          ),
          8.height,
          _buildDetailRow(
            label: 'Bank Name:',
            value: bankName,
            icon: Icons.account_balance,
          ),
          8.height,
          _buildDetailRow(
            label: 'Branch/Address:',
            value: branch,
            icon: Icons.location_on,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({required String label, required String value, required IconData icon}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: txtdarkgrayColor),
        8.width,
        Expanded(
          child: RichText(
            text: TextSpan(
              style: AppTextStyles.light.copyWith(fontSize: 14, color: blackColor),
              children: [
                TextSpan(
                  text: '$label ',
                  style:  AppTextStyles.subHeading.copyWith(fontWeight: FontWeight.w500,fontSize: 12),
                ),
                TextSpan(
                  text: value,
                  style: AppTextStyles.regular.copyWith(fontWeight: FontWeight.normal,fontSize: 10),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

