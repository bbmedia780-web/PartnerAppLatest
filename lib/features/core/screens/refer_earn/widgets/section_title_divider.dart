import '../../../../../utils/library_utils.dart';

class SectionTitleWithDivider extends StatelessWidget {
  final String title;

  const SectionTitleWithDivider({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left line
        Expanded(
          child: Divider(
            color: Colors.deepPurple.shade200,
            thickness: 1,
          ),
        ),

        const SizedBox(width: 12),

        // Center text
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),

        const SizedBox(width: 12),

        // Right line
        Expanded(
          child: Divider(
            color: Colors.deepPurple.shade200,
            thickness: 1,
          ),
        ),
      ],
    );
  }
}
