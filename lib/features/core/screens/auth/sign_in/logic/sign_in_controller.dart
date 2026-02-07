import '../../../../../../utils/library_utils.dart';

class SignInController extends GetxController {
  SignInApiProvider provider = SignInApiProvider();
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var otp = ''.obs;

  LabeledGlobalKey<FormState> formKey = LabeledGlobalKey<FormState>('signin');
  bool isLoading = false;
  RxBool isButtonEnable = false.obs;
  RxBool isOtpView = false.obs;
  RxInt pageIndex = 0.obs;
  RxString maskedPhoneNumber = ''.obs;
  
  List<String> lstImgs = [
    AppImages.img1,
    AppImages.img2,
    AppImages.img3,
  ];

  @override
  void onInit() {
    super.onInit();
    mobileNoController.addListener(_onPhoneNumberChanged);
  }

  @override
  void onClose() {
    mobileNoController.removeListener(_onPhoneNumberChanged);
    mobileNoController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void _onPhoneNumberChanged() {
    _checkButtonState();
  }

  void _checkButtonState() {
    if (isOtpView.value) {
      // For OTP view, enable button if OTP is 6 digits
      isButtonEnable.value = otp.value.length == 6;
    } else {
      // For phone input view, enable button if phone number is valid (10 digits)
      final phone = mobileNoController.text.trim();
      isButtonEnable.value = RegExp(r'^\d{10}$').hasMatch(phone);
    }
  }

  bool validatePhoneNumber() {
    final phone = mobileNoController.text.trim();
    if (phone.isEmpty) {
      return false;
    }
    return RegExp(r'^\d{10}$').hasMatch(phone);
  }

  bool validateOtp() {
    return otp.value.length == 6;
  }

  String getMaskedPhoneNumber() {
    final phone = mobileNoController.text.trim();
    if (phone.length >= 4) {
      final last4 = phone.substring(phone.length - 4);
      return 'XXXXXX$last4';
    }
    return phone.isNotEmpty ? phone : '';
  }

  changePageIndex(int index) {
    pageIndex.value = index;
    update();
  }

  void onOtpChanged(String value) {
    otp.value = value;
    _checkButtonState();
  }

  void onOtpViewChanged(bool value) {
    isOtpView.value = value;
    _checkButtonState();
  }
  onLoginUserApi() async {
    var data = {
      "mobile": mobileNoController.text.trim(),
      "password": passwordController.text.trim(),
      // "fcmToken": getString(preFcmToken, "")
    };
    await loginUser(data);
  }

  loginUser(data) async {
    // isLoading = true;
    // update();
    // var response = await provider.loginUser(data: data);
    //
    // if (response?.statusCode == 200 || response?.statusCode == 201) {
    //   // ResRegisterUserData registerUserData =
    //   //     ResRegisterUserData.fromJson(response?.data);
    //   //
    //   // if (registerUserData.user.token.isNotEmpty) {
    //   //   setString(prefUserToken, registerUserData.user.token);
    //   //   setString(prefCurrentUserId, registerUserData.user.id ?? "");
    //   //   setString(
    //   //       prefCurrentUserName,
    //   //       "${registerUserData.user.firstName} ${registerUserData.user.lastName}" ??
    //   //           "");
    //   //   Get.offAndToNamed(AppRoutes.homeScreen);
    //   // }
    //   isLoading = false;
    //   update();
    // } else {
    //   isLoading = false;
    //   update();
    // }
  }
}
