import '../../../../../../utils/library_utils.dart';

class ReferralSummaryCard extends StatelessWidget {
  final String value;
  final String label;

  const ReferralSummaryCard({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFBE1E1), width: 1),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xffFEF3F1),
            Color(0xFFEFE2FB),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: AppTextStyles.subHeading.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: purpleDarkColor,
            ),
          ),
          4.height,
          Text(
            label,
            style: AppTextStyles.light.copyWith(
              fontSize: 11,
              color: greyLight,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}

