
import '../../../../../../utils/library_utils.dart';


class KycController extends GetxController {
  final VerificationService _verificationService = Get.find<VerificationService>();
  final GlobalKey<FormState> identityFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> bankFormKey = GlobalKey<FormState>();

  // Identity Text Controllers
  final TextEditingController aadhaarController = TextEditingController();
  final TextEditingController panController = TextEditingController();
  final TextEditingController gstNumController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  // Bank Text Controllers
  final TextEditingController accNameController = TextEditingController();
  final TextEditingController accNumberController = TextEditingController();
  final TextEditingController ifscController = TextEditingController();

  // Loading and Status States
  var isIdentityLoading = false.obs;
  var isBankLoading = false.obs;
  var canSendOtp = false.obs;
  var canVerifyPan = false.obs;
  var canVerifyGst = false.obs;

  var isOtpSending = false.obs;
  var isVerifyingPan = false.obs;
  var isVerifyingGst = false.obs;

  var showOtpField = false.obs;
  // Verification Statuses (Using RxMap for dynamic updates)
  var verificationStatuses = <String, VerificationResponse?>{
    'aadhaar': null,
    'pan': null,
    'gstin': null,
    'bank': null,
  }.obs;

  @override
  void onInit() {
    // Register the service dependency
    Get.put(VerificationService());
    aadhaarController.addListener(updateButtonStates);
    mobileController.addListener(updateButtonStates);
    panController.addListener(updateButtonStates);
    gstNumController.addListener(updateButtonStates);
    super.onInit();
  }

  @override
  void onClose() {
    aadhaarController.dispose();
    panController.dispose();
    gstNumController.dispose();
    accNameController.dispose();
    accNumberController.dispose();
    ifscController.dispose();
    mobileController.dispose();
    super.onClose();
  }

  // --- Verification Logic ---
  void updateButtonStates() {
    final aadhaar = aadhaarController.text.trim();
    final mobile = mobileController.text.trim();
    final pan = panController.text.trim();
    final gst = gstNumController.text.trim();

    canSendOtp.value = aadhaar.length == 12 && mobile.length == 10;
    canVerifyPan.value = Validators().validatePan(pan) == null && pan.length == 10;
    canVerifyGst.value = gst.isEmpty || (Validators().validateGSTNo(gst) == null && gst.length == 15);
  }

  Future<void> verifyPan() async {
    isVerifyingPan.value = true;
    // final result = await VerificationService.verifyPAN(panController.text.trim());
    // isVerifyingPan.value = false;
    //
    // if (result != null && result['valid'] == true) {
    //   Get.snackbar("Success", "PAN Verified Successfully!", backgroundColor: Colors.green);
    //   // Save data or proceed
    // } else {
    //   Get.snackbar("Failed", result?['message'] ?? "Invalid PAN", backgroundColor: Colors.red);
    // }
  }

  Future<void> verifyGst() async {
    if (gstNumController.text.trim().isEmpty) return;
    isVerifyingGst.value = true;
    // Call GST API
    isVerifyingGst.value = false;
  }
  Future<void> verifyIdentity() async {
    if (!identityFormKey.currentState!.validate()) {
      return;
    }

    isIdentityLoading.value = true;

    // Aadhaar Verification (Usually requires OTP flow, here simplified)
    VerificationResponse aadhaarRes = await _verificationService.verifyAadhaar(aadhaarController.text.trim());
    verificationStatuses['aadhaar'] = aadhaarRes;

    // PAN Verification
    VerificationResponse panRes = await _verificationService.verifyPan(panController.text.trim());
    verificationStatuses['pan'] = panRes;

    // GSTIN Verification
    VerificationResponse gstinRes = await _verificationService.verifyGstin(gstNumController.text.trim());
    verificationStatuses['gstin'] = gstinRes;

    isIdentityLoading.value = false;

    // Show a general feedback
    ShowToast.success('Aadhaar: ${aadhaarRes.status}, PAN: ${panRes.status}, GSTIN: ${gstinRes.status}');
  }

  Future<void> verifyBankDetails() async {
    if (!bankFormKey.currentState!.validate()) {
      return;
    }

    isBankLoading.value = true;

    // Bank Account Verification (Penny Drop)
    VerificationResponse bankRes = await _verificationService.verifyBank(
      accNumberController.text.trim(),
      ifscController.text.trim(),
      accNameController.text.trim(),
    );
    verificationStatuses['bank'] = bankRes;

    isBankLoading.value = false;

    // Show a general feedback
    if (bankRes.status == 'SUCCESS') {
      final nameAtBank = bankRes.verificationData?['nameAtBank'] ?? 'N/A';
      ShowToast.success('Bank Verification SUCCESS! Account Name: $nameAtBank');
    } else {
      ShowToast.error('Bank Verification Failed: ${bankRes.message}');
    }
  }

  // --- Helper for UI Status ---

  Icon getStatusIcon(String key) {
    final status = verificationStatuses[key]?.status;
    if (status == 'SUCCESS') {
      return const Icon(Icons.check_circle, color: Colors.green, size: 20);
    } else if (status == 'INVALID' || status == 'ERROR') {
      return const Icon(Icons.cancel, color: Colors.red, size: 20);
    }
    return const Icon(Icons.info_outline, color: Colors.grey, size: 20);
  }
}