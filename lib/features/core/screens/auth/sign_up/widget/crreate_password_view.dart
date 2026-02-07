import '../../../../../../utils/library_utils.dart';

class CreatePasswordView extends StatelessWidget {
  const CreatePasswordView({super.key, required this.controller});

  final SignUpController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          10.height,
          Text(
            "Create password",
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                color: appBlack,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ),
          10.height,
          Text(
            "Please create a password to\ncomplete registration.",
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                color: txtdarkgrayColor,
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),
          ),
          20.height,
          CustomTextField(
              isPassword: true,
              minLine: 1,
              hintText: "*****",
              onChange: (val) {
                controller.checkPasswordValidation(val);
              },
              labelName: "",
              controller: controller.passwordController),
          10.height,
          validationText(text: "Password strenght: weak", isValidate: controller.passStrenght),
          8.height,
          validationText(text: "Must be at least 8 characters", isValidate: controller.charactersLength),
          8.height,
          validationText(text: "Can’t include your name or email address", isValidate: controller.includeEmailAddress),
          8.height,
          validationText(text: "Must have at least one symbol or number", isValidate: controller.oneNumberAndSymbol),
          8.height,
          validationText(text: "Can’t contain spaces", isValidate: controller.containSpaces),
          8.height,
        ],
      ),
    );
  }

  Widget validationText({required String text, required bool isValidate}) {
    return Row(
      children: [
        Icon(
          isValidate ? Icons.check : Icons.close,
          color: isValidate ? txtdarkgrayColor : errorColor,
          size: 17,
        ),
        5.width,
        Text(
          text,
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              color: isValidate ? txtdarkgrayColor : errorColor,
              fontWeight: FontWeight.w400,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
