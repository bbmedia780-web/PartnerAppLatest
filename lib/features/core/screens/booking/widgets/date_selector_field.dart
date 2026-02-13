import '../../../../../../utils/library_utils.dart';

class DateSelectorField extends StatelessWidget {
  final String selectedDate;
  final Function(String) onDateSelected;

  const DateSelectorField({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),border: Border.all(color: dividerColor)),
       child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
           Padding(
             padding: const EdgeInsets.only(left: 15,top: 8,bottom: 8,right: 8),
             child: Text(selectedDate,style: AppTextStyles.subHeading.copyWith(fontSize: 12,color: kColorGray),),
           ),
           Container(color: appColor.withValues(alpha:0.1),child: Padding(
             padding: const EdgeInsets.all(8.0),
             child: SizedBox(
                 height: 25,
                 width: 25,
                 child: Image.asset(AppImages.calenderIcon,color: appColor,)),
           ),)
         ],
       ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]}, ${date.year}';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
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
      final formattedDate = _formatDate(picked);
      onDateSelected(formattedDate);
    }
  }
}

