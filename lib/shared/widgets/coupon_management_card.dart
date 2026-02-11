
import '../../../../../utils/library_utils.dart';

class CouponManagementCard extends StatelessWidget {
  final int activeCouponsCount;
  final VoidCallback? onViewStatus;
  final VoidCallback? onHistory;

  const CouponManagementCard({
    super.key,
    required this.activeCouponsCount,
    this.onViewStatus,
    this.onHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12
          , vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: kColorBlue,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: whiteColor.withValues(alpha:0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.card_giftcard,
                  color: whiteColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Coupon management',
                      style: AppTextStyles.regular.copyWith(
                        color: whiteColor.withValues(alpha:0.9),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$activeCouponsCount Active coupons.',
                      style: AppTextStyles.heading2.copyWith(
                        color: whiteColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  icon: Icons.visibility,
                  label: 'View status',
                  onTap: onViewStatus,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  icon: Icons.history,
                  label: 'History',
                  onTap: onHistory,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: whiteColor.withValues(alpha:0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: whiteColor, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.button.copyWith(
                fontSize: 14,
                color: whiteColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

