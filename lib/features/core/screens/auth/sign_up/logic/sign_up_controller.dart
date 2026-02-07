import '../../../../../../utils/library_utils.dart';

class SignUpController extends GetxController {
  SignUpApiProvider signUpApiProvider = SignUpApiProvider();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController secondNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController countryNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxInt pageIndex = 0.obs;

  bool passStrenght = false;
  bool charactersLength = false;
  bool includeEmailAddress = false;
  bool containSpaces = false;
  bool oneNumberAndSymbol = false;
  bool isButtonEnable = false;

  bool isLoading = false;
  LabeledGlobalKey<FormState> formKeySignUp =
      LabeledGlobalKey<FormState>('signup');
  RxBool isFormComplete = false.obs;

  onCheckButtonActivate() {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(emailController.text.trim());
    bool passValid = passwordController.text.trim().length >= 6;
    if (emailValid || passValid) {
      isButtonEnable = true;
    } else {
      isButtonEnable = false;
    }
    update();
  }

  onSelectCountry(String name) {
    countryNameController.text = name;
    onCheckButtonActivate();

    update();
  }

  changePageIndex(int index) {
    pageIndex.value = index;
    update();
  }

  onChangeDetailsView() {
    isFormComplete.value = !isFormComplete.value;
    update();
  }

  /// check create password validation
  checkPasswordValidation(String password) {
    String email = emailController.text.trim();
    String name =
        "${firstNameController.text.trim()} ${secondNameController.text.trim()}";
    if (password.length < 8) {
      charactersLength = false;
    } else {
      charactersLength = true;
    }

    if (password.contains(' ')) {
      containSpaces = false;
    } else {
      containSpaces = true;
    }

    if (password.contains(name) || password.contains(email)) {
      includeEmailAddress = false;
    } else {
      includeEmailAddress = true;
    }
    final RegExp symbolRegex =
        RegExp(r'^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[\W_]).{8,}$');
    bool isSymb = false;

    if (!symbolRegex.hasMatch(password)) {
      isSymb = false;
    } else {
      isSymb = true;
    }
    if (isSymb) {
      oneNumberAndSymbol = true;
    } else {
      oneNumberAndSymbol = false;
    }

    if (oneNumberAndSymbol == true &&
        includeEmailAddress == true &&
        containSpaces == true &&
        charactersLength == true) {
      passStrenght = true;
    } else {
      passStrenght = false;
    }
    update();
  }

  /// Register user api call

  onRegisterUserApi() async {
    if (passStrenght) {
      var data = {
        "firstName": firstNameController.text.trim(),
        "lastName": secondNameController.text.trim(),
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
        "country": countryNameController.text.trim(),
        // "fcmToken":
        //     getString(preFcmToken).isNotEmpty ? getString(preFcmToken) : ""
      };
      await registerUser(data);
    }
  }

  registerUser(data) async {
    // isLoading = true;
    // update();
    // var response = await signUpApiProvider.registerUserApiCall(data: data);
    //
    // if (response?.statusCode == 200 || response?.statusCode == 201) {
    //   // ResRegisterUserData registerUserData =
    //   //     ResRegisterUserData.fromJson(response?.data);
    //   // if (registerUserData.user.token.isNotEmpty) {
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
