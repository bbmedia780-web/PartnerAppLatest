
import '../../../../../../utils/library_utils.dart';

class KycVerificationController extends GetxController {
  final CashfreeKycService _kycService = CashfreeKycService();

  // Current step (0: Aadhaar, 1: PAN, 2: GST, 3: Bank)
  var currentStep = 0.obs;
  var totalSteps = 4;

  // Aadhaar Verification
  var aadhaarNumber = ''.obs;
  var mobileNumber = ''.obs;
  var aadhaarOtp = ''.obs;
  var aadhaarVerificationId = ''.obs;
  var aadhaarReferenceId = 0.obs;
  var isAadhaarOtpSent = false.obs;
  var isAadhaarVerified = false.obs;
  var isGeneratingAadhaarOtp = false.obs;
  var isVerifyingAadhaarOtp = false.obs;

  // PAN Verification
  var panNumber = ''.obs;
  var isPanVerified = false.obs;
  var isVerifyingPan = false.obs;

  // GST Verification
  var gstinNumber = ''.obs;
  var isGstVerified = false.obs;
  var isVerifyingGst = false.obs;
  var isGstSkipped = false.obs;

  // Bank Verification
  var accountHolderName = ''.obs;
  var accountNumber = ''.obs;
  var ifscCode = ''.obs;
  var isBankVerified = false.obs;
  var isVerifyingBank = false.obs;

  // Text Controllers
  final aadhaarController = TextEditingController();
  final mobileController = TextEditingController();
  final otpController = TextEditingController();
  final panController = TextEditingController();
  final gstinController = TextEditingController();
  final accountNameController = TextEditingController();
  final accountNumberController = TextEditingController();
  final ifscController = TextEditingController();

  // Form Keys
  final aadhaarFormKey = GlobalKey<FormState>();
  final panFormKey = GlobalKey<FormState>();
  final gstFormKey = GlobalKey<FormState>();
  final bankFormKey = GlobalKey<FormState>();
  var aadhaarData = {}.obs;
  RxMap<String,dynamic> verifiedBankDetails = <String,dynamic>{}.obs;

  @override
  void onClose() {
    aadhaarController.dispose();
    mobileController.dispose();
    otpController.dispose();
    panController.dispose();
    gstinController.dispose();
    accountNameController.dispose();
    accountNumberController.dispose();
    ifscController.dispose();
    super.onClose();
  }

  // Navigation
  void nextStep() {
    if (currentStep.value < totalSteps - 1) {
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step < totalSteps) {
      currentStep.value = step;
    }
  }

  // Aadhaar Verification
  Future<void> generateAadhaarOTP() async {
    if (!aadhaarFormKey.currentState!.validate()) {
      return;
    }

    if (aadhaarController.text.trim().length != 12) {
      ShowToast.error('Please enter valid 12-digit Aadhaar number');
      return;
    }

    // if (mobileController.text.trim().length != 10) {
    //   ShowToast.error('Please enter valid 10-digit mobile number');
    //   return;
    // }

    isGeneratingAadhaarOtp.value = true;
    aadhaarNumber.value = aadhaarController.text.trim();
    mobileNumber.value = mobileController.text.trim();

    final result = await _kycService.generateAadhaarOTP(
      aadhaarNumber: aadhaarNumber.value,
      // mobileNumber: mobileNumber.value,
    );

    isGeneratingAadhaarOtp.value = false;

    if (result != null && result['success'] == true) {
      aadhaarVerificationId.value = result['verification_id'] ?? '';
      aadhaarReferenceId.value = int.tryParse(result['reference_id'].toString()) ?? 0;
      isAadhaarOtpSent.value = true;
      ShowToast.success('OTP sent to your mobile number');
    } else {
      print('Error : ${result?['message'].toString()}');

      ShowToast.error(result?['message'] ?? 'Failed to send OTP');
    }
  }
  Future<void> verifyAadhaarOTP() async {
    if (!aadhaarFormKey.currentState!.validate()) {
      return;
    }

    if (otpController.text.trim().length != 6) {
      ShowToast.error('Please enter valid 6-digit OTP');
      return;
    }

    isVerifyingAadhaarOtp.value = true;

    final result = await _kycService.verifyAadhaarOTP(
      otp: otpController.text.trim(),
      referenceId: aadhaarReferenceId.value,
    );

    isVerifyingAadhaarOtp.value = false;

    if (result != null && result['success'] == true) {
      // Verification success
      isAadhaarVerified.value = true;
      ShowToast.success('Aadhaar verified successfully');

      // Optionally store returned data for further use
      aadhaarData.value = result['data'] ?? {};
      Future.delayed(const Duration(seconds: 1), () {
        nextStep();
      });
    } else {
      print('Error: ${result?['message']}');
      ShowToast.error(result?['message'] ?? 'OTP verification failed');
    }
  }

  // PAN Verification
  Future<void> verifyPAN() async {
    if (!panFormKey.currentState!.validate()) {
      return;
    }

    isVerifyingPan.value = true;
    panNumber.value = panController.text.trim().toUpperCase();

    final result = await _kycService.verifyPAN(panNumber.value);
    isVerifyingPan.value = false;
    if (result != null && result['success'] == true) {
      isPanVerified.value = true;
      ShowToast.success('PAN verified successfully!');
      Future.delayed(const Duration(seconds: 1), () {
        nextStep();
      });
    } else {
      ShowToast.error(result?['message'] ?? 'PAN verification failed');
    }
  }

  // GST Verification
  Future<void> verifyGST() async {
    if (gstinController.text.trim().isEmpty) {
      skipGST();
      return;
    }

    if (!gstFormKey.currentState!.validate()) {
      return;
    }

    isVerifyingGst.value = true;
    gstinNumber.value = gstinController.text.trim().toUpperCase();

    final result = await _kycService.verifyGSTIN(gstinNumber.value);

    isVerifyingGst.value = false;

    if (result != null && result['success'] == true) {
      isGstVerified.value = true;
      ShowToast.success('GSTIN verified successfully!');
      Future.delayed(const Duration(seconds: 1), () {
        nextStep();
      });
    } else {
      ShowToast.error(result?['message'] ?? 'GSTIN verification failed');
    }
  }

  void skipGST() {
    isGstSkipped.value = true;
    ShowToast.success('GST verification skipped');
    Future.delayed(const Duration(seconds: 1), () {
      nextStep();
    });
  }

  // Bank Verification
  Future<void> verifyBank() async {
    if (!bankFormKey.currentState!.validate()) {
      return;
    }
    isVerifyingBank.value = true;
    accountHolderName.value = accountNameController.text.trim();
    accountNumber.value = accountNumberController.text.trim();
    ifscCode.value = ifscController.text.trim().toUpperCase();

    final result = await _kycService.verifyBankAccount(
      accountNumber: accountNumber.value,
      ifscCode: ifscCode.value,
      accountHolderName: accountHolderName.value,
    );

    isVerifyingBank.value = false;

    print("Result ==== $result");
    if (result == null) {
      _clearFailedBankDetails();
      ShowToast.error("Bank verification failed");
      return;
    }
    if (result['type'] == "validation_error") {
      _clearFailedBankDetails();
      ShowToast.error(result['message'] ?? "Bank verification failed");
      return;
    }
    final data = result['data'];
    if (data == null) {
      _clearFailedBankDetails();
      ShowToast.error("Invalid bank details");
      return;
    }
    final bankName = data['bank_name']?.toString() ?? "NOT_AVAILABLE";

    print("Bank Name :: $bankName");

    if (bankName != "NOT_AVAILABLE") {
      // SUCCESS
      verifiedBankDetails.value = data;
      isBankVerified.value = true;
      ShowToast.success("Bank account verified successfully!");
    } else {
      // FAILED / INVALID ACCOUNT
      _clearFailedBankDetails();
      ShowToast.error("Please enter valid bank details");
    }
  }
  void _clearFailedBankDetails() {
    verifiedBankDetails.value = {};
    isBankVerified.value = false;
  }
  void _onAllVerificationsComplete() {
    ShowToast.success('All KYC verifications completed!');
    // Future.delayed(const Duration(seconds: 2), () {
    //   Get.back();
    // });
  }

  // Check if can proceed to next step
  bool canProceedToNext() {
    switch (currentStep.value) {
      case 0:
        return isAadhaarVerified.value;
      case 1:
        return isPanVerified.value;
      case 2:
        return isGstVerified.value || isGstSkipped.value;
      case 3:
        return isBankVerified.value;
      default:
        return false;
    }
  }
}

