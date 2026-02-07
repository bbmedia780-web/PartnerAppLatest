import '../../utils/library_utils.dart';

class CustomTextField extends StatefulWidget {
  final String labelName;
  final Color labelColor;
  final Color? fillColor;
  final bool isPassword;
  final bool isDescription;
  final bool isSuffix;
  final bool onlyRead;
  final Widget? suffixWidget;
  final void Function()? onTap;
  final void Function()? onComplete;
  final void Function(String)? onChange;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final Iterable<String>? autofillHints;
  final void Function()? isVisibleOnTap;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? textInputType;
  final bool? isMobile;
  final Widget? prefixIcon;
  final int? minLine;
  final int? maxLine;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final bool showBorder;
  final double? borderRadius;
  final EdgeInsets? contentPadding;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final TextStyle? textStyle;
  final TextStyle? hintTextStyle;
  final FocusNode? focusNode;
  final bool filled;
  final String? counterText;

  const CustomTextField(
      {super.key,
      required this.labelName,
      required this.controller,
      this.isPassword = false,
      this.isDescription = false,
      this.onlyRead = false,
      this.isVisibleOnTap,
      this.fillColor,
      this.isSuffix = false,
      this.labelColor = Colors.white,
      this.suffixWidget,
      this.autofillHints,
      this.hintText,
      this.inputFormatters,
      this.textInputType,
      this.isMobile,
      this.maxLine,
      this.prefixIcon,
      this.minLine,
      this.onTap,
      this.onChange,
      this.maxLength,
      this.textInputAction,
      this.validator,
      this.showBorder = true,
      this.borderRadius,
      this.contentPadding,
      this.border,
      this.enabledBorder,
      this.focusedBorder,
      this.textStyle,
      this.onComplete,
      this.hintTextStyle,
      this.focusNode,
      this.filled = false,
      this.counterText});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelName.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(
              widget.labelName,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w500, color: appBlack),
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0),
          child: TextFormField(
            autofocus: false,
            focusNode: widget.focusNode,
            onTap: widget.onTap,
            onChanged: widget.onChange,
            textInputAction: widget.textInputAction ?? TextInputAction.next,
            minLines: widget.minLine ?? 1,
            maxLength: widget.maxLength,
            maxLines: widget.maxLine ?? (widget.isDescription ? 6 : 1),
            autofillHints: widget.autofillHints,
            inputFormatters: widget.inputFormatters,
            keyboardType: widget.textInputType,
            style: widget.textStyle ?? GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400),
            validator: widget.validator,
            controller: widget.controller,
            readOnly: widget.onlyRead,
            obscureText: widget.isPassword,
            onEditingComplete: widget.onComplete,
            decoration: InputDecoration(
              prefixIcon: widget.prefixIcon,
              suffix: widget.suffixWidget,
              hintText: widget.hintText,
              hintStyle: widget.hintTextStyle ?? GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: kColorGray),
              filled: widget.filled || (widget.isMobile != null ? true : false),
              fillColor: widget.fillColor ?? const Color(0xFFFCFCFC),
              errorMaxLines: 1,
              errorStyle: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400, color: errorColor),
              contentPadding: widget.contentPadding ?? const EdgeInsets.only(top: 10, left: 20, bottom: 0),
              counterText: widget.counterText ?? (widget.maxLength != null ? '' : null),
              errorBorder: widget.showBorder
                  ? (widget.border ?? customFieldBorder)
                  : InputBorder.none,
              disabledBorder: widget.showBorder
                  ? (widget.enabledBorder ?? widget.border ?? customFieldBorder)
                  : InputBorder.none,
              focusedBorder: widget.showBorder
                  ? (widget.focusedBorder ?? widget.border ?? customFieldBorder)
                  : InputBorder.none,
              focusedErrorBorder: widget.showBorder
                  ? (widget.border ?? customFieldBorder)
                  : InputBorder.none,
              enabledBorder: widget.showBorder
                  ? (widget.enabledBorder ?? widget.border ?? customFieldBorder)
                  : InputBorder.none,
              border: widget.showBorder
                  ? (widget.border ?? customFieldBorder)
                  : InputBorder.none,
              suffixIcon: widget.isSuffix
                  ? GestureDetector(onTap: widget.isVisibleOnTap, child: widget.suffixWidget)
                  : const SizedBox(
                      width: 0,
                      height: 0,
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

OutlineInputBorder customFieldBorder=OutlineInputBorder(
borderRadius: BorderRadius.circular(10),
  borderSide: BorderSide(width: 1, color: dividerColor.withValues(alpha: 0.5)),
);