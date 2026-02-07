import '../../utils/library_utils.dart';

class DecoratedDropdownField extends StatelessWidget {
  final String hint;
  final RxString value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const DecoratedDropdownField({
    super.key,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
          color: Colors.white,
        ),
        child: Row(
          children: [
            /// DROPDOWN
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButtonFormField<String>(
                  value: value.value.isEmpty ? null : value.value,
                  hint: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      hint,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  icon: const SizedBox.shrink(), // hide default arrow
                  items: items
                      .map(
                        (item) => DropdownMenuItem(
                      value: item,
                      child: Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 14),
                        child: Text(item,style: AppTextStyles.regular.copyWith(fontSize: 14),),
                      ),
                    ),
                  )
                      .toList(),
                  onChanged: onChanged,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),

            /// RIGHT PINK AREA
            Container(
              width: 50,
              height: double.infinity,
              decoration:  BoxDecoration(
                color: appColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: appColor,
              ),
            ),
          ],
        ),
      );
    });
  }
}
