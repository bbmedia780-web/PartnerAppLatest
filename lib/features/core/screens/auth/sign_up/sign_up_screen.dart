import 'package:country_picker/country_picker.dart';
import '../../../../../utils/library_utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  SignUpController signUpController = Get.put(SignUpController());

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appWhite,
      appBar: PreferredSize(
        preferredSize: Size(Get.width, 60),
        child: GetBuilder<SignUpController>(builder: (controller) {
          return AppBar(
            leading: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: appBlack,
                ),
              ),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            bottom: PreferredSize(
                preferredSize: Size(Get.width, 10),
                child: Stack(
                  children: [
                    Container(
                      height: 3,
                      width: Get.width,
                      color: dividerColor,
                    ),
                    Container(
                      height: 3,
                      color: appColor,
                      width: !controller.isFormComplete.value
                          ? Get.width * 0.30
                          : Get.width * 0.70,
                    ),
                  ],
                )),
            centerTitle: true,
            title: Text(
              "Sing up",
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  color: appBlack,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          );
        }),
      ),
      body: GetBuilder<SignUpController>(builder: (controller) {
        return controller.isFormComplete.value
            ? CreatePasswordView(
                controller: controller,
              )
            : Padding(
                padding: const EdgeInsets.all(15),
                child: Form(
                  key: controller.formKeySignUp,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        10.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Participate in stake",
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  color: appBlack,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                     10.height,

                        CustomTextField(
                            onTap: () {
                              showCountryPicker(
                                context: context,
                                showPhoneCode: true,
                                // optional. Shows phone code before the country name.
                                onSelect: (Country country) {
                                  controller.onSelectCountry(country.name);
                                },
                              );
                            },
                            onlyRead: true,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Select your country.";
                              }
                              return null;
                            },
                            labelName: "Country",
                            hintText: 'India',
                            controller: controller.countryNameController),
                        10.height,
                      ],
                    ),
                  ),
                ),
              );
      }),
      bottomNavigationBar: SizedBox(
        height: 92,
        child: GetBuilder<SignUpController>(builder: (controller) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Divider(
                color: dividerColor,
              ),
              controller.isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(15),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: appBlack,
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, top: 10, bottom: 10),
                      child: CustomButton(
                        title: "Continue",
                        isDisable: controller.isButtonEnable ||
                                controller.passStrenght
                            ? false
                            : true,
                        onTap: () async {
                          if (!controller.isFormComplete.value) {
                            if (controller.formKeySignUp.currentState!
                                .validate()) {
                              controller.onChangeDetailsView();
                            }
                          } else {
                            await controller.onRegisterUserApi();
                          }
                        },
                      ),
                    )
            ],
          );
        }),
      ),
    );
  }
}
