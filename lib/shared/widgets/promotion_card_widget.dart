import '../../../../../utils/library_utils.dart';

class PromotionCardWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String status;
  final Map<String, String> metrics;
  final String budget;
  final Widget? icon;
  final VoidCallback? onEdit;
  final VoidCallback? onPush;
  final VoidCallback? onDeactivate;
  final bool isCoupon;

  const PromotionCardWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.metrics,
    required this.budget,
    this.icon,
    this.onEdit,
    this.onPush,
    this.onDeactivate,
    this.isCoupon = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: lightTealColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: icon,
                ),
                12.width,
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.subHeading.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: blackColor,
                      ),
                    ),
                    4.height,
                    Text(
                      subtitle,
                      style: AppTextStyles.light.copyWith(
                        fontSize: 12,
                        color: txtdarkgrayColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: successColor.withValues(alpha:0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: AppTextStyles.light.copyWith(
                    fontSize: 12,
                    color: successColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          10.height,
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: metrics.entries.map((entry) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: cardgreyColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: AppTextStyles.light.copyWith(
                        fontSize: 10,
                        color: txtdarkgrayColor,
                      ),
                    ),
                    2.height,
                    Text(
                      entry.value,
                      style: AppTextStyles.regular.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: blackColor,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          8.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                budget,
                style: AppTextStyles.light.copyWith(
                  fontSize: 12,
                  color: txtdarkgrayColor,
                ),
              ),
              Row(
                children: [
                  if (onEdit != null)
                    _buildActionButton(
                      label: 'Edit',
                      onTap: onEdit,
                      isPrimary: false,
                    ),
                  if (onPush != null) ...[
                    const SizedBox(width: 8),
                    _buildActionButton(
                      label: 'Push',
                      onTap: onPush,
                      isPrimary: true,
                    ),
                  ],
                  if (onDeactivate != null) ...[
                    const SizedBox(width: 8),
                    _buildActionButton(
                      label: 'Deactivate',
                      onTap: onDeactivate,
                      isPrimary: false,
                      isDestructive: true,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    VoidCallback? onTap,
    bool isPrimary = false,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: isPrimary
              ? kColorOrange.withValues(alpha:0.1)
              : isDestructive
                  ? Colors.transparent
                  : cardgreyColor,
          borderRadius: BorderRadius.circular(8),
          border: isDestructive
              ? Border.all(color: errorColor, width: 1)
              : isPrimary
                  ? Border.all(color: kColorOrange, width: 1)
                  : null,
        ),
        child: Text(
          label,
          style: AppTextStyles.regular.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDestructive
                ? errorColor
                : isPrimary
                    ? kColorOrange
                    : blackColor,
          ),
        ),
      ),
    );
  }
}

