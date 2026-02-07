import '../../../../../../utils/library_utils.dart';

class EditProfileScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ProfileController>()) {
      ProfileBinding().dependencies();
    }
    final controller = Get.find<ProfileController>();

    return Scaffold(
      appBar: CustomAppBar(title: "Edit Profile"),
      backgroundColor: whiteColor,
        bottomNavigationBar: SafeArea(
          child: SizedBox(
            height: 80,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: CustomButton(
                title: "Save",
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    // Save profile logic here
                    Get.back();
                  }
                },
                isDisable: false,
              ),
            ),
          ),
        ),

        body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: formKey,
          child: Column(
            children: [
            GestureDetector(
            onTap: () {
              controller.pickProfileImage();
             },
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Obx(() => CircleAvatar(
              backgroundColor: appColor,
              radius: 62,
              child: CircleAvatar(
                backgroundColor: borderGreyColor,
                radius: 60,
                backgroundImage: controller.profileImage.value != null
                    ? FileImage(controller.profileImage.value!)
                    : null,
                child: controller.profileImage.value == null
                    ? Center(
                  child: Icon(Icons.image_outlined, color: kColorGray),
                )
                    : null,
              ),
            )),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: appColor,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(5),
                  child: Icon(Icons.camera_alt, color: Colors.white, size: 18),
                ),
              ),
            ),
          ],
        ),
      ),
      CustomTextField(
        labelName: 'User Name',
        controller: controller.userNameController,
        hintText: 'ex.Absert Patel',
        validator: (value) => Validators().requiredField(value),
      ),
            8.height,
            CustomTextField(
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              textInputType: TextInputType.phone,
              labelName: 'Mobile No',
              hintText: '8900760089',
              controller: controller.phoneNumberController,
              validator: (value) => Validators().validateMobile(value),
            ),
            8.height,
            CustomTextField(
              labelName: 'Email',
              controller: controller.emailController,
              hintText: 'ex.test@gmail.com',
              textInputType: TextInputType.emailAddress,
              validator: (value) => Validators().validateEmail(value),
            ),

          ],
        ),
      ),
    ));
  }
}
