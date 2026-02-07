import 'package:intl/intl.dart';

import '../../../../../utils/library_utils.dart';

class DateSelectorField extends StatelessWidget {
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? hintText;
  final String? dateFormat;
  final bool enabled;

  const DateSelectorField({
    super.key,
    this.selectedDate,
    required this.onDateSelected,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.hintText,
    this.dateFormat,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final displayText = selectedDate != null
        ? _formatDate(selectedDate!, dateFormat)
        : (hintText ?? 'Select Date');

    return GestureDetector(
      onTap: enabled ? () => _selectDate(context) : null,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: dividerColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 8, bottom: 8, right: 8),
              child: Text(
                displayText,
                style: AppTextStyles.subHeading.copyWith(
                  fontSize: 12,
                  color: selectedDate != null ? blackColor : kColorGray,
                ),
              ),
            ),
            Container(
              color: appColor.withValues(alpha: 0.1),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 25,
                  width: 25,
                  child: Image.asset(
                    AppImages.calenderIcon,
                    color: appColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date, String? format) {
    if (format != null) {
      try {
        return DateFormat(format).format(date);
      } catch (e) {
        // Fallback to default format if custom format fails
      }
    }
    
    // Default format: "22 July, 2025"
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]}, ${date.year}';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? selectedDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(2020),
      lastDate: lastDate ?? DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: appColor,
              onPrimary: whiteColor,
              surface: whiteColor,
              onSurface: blackColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onDateSelected(picked);
    }
  }
}

