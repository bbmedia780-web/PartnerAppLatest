import '../../../../../model/payment_model.dart';
import '../../../../../utils/library_utils.dart';

class PaymentListItem extends StatelessWidget {
  final PaymentModel payment;

  const PaymentListItem({
    super.key,
    required this.payment,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Row(
            children: [
              // Profile Image
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: borderGreyColor,
                  image: payment.customerImage.isNotEmpty
                      ? DecorationImage(
                          image: AssetImage(payment.customerImage),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: payment.customerImage.isEmpty
                    ? Icon(Icons.person, color: kColorGray, size: 30)
                    : null,
              ),
              12.width,
              // Name and Date
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      payment.customerName,
                      style: AppTextStyles.subHeading.copyWith(
                        fontSize: 14,
                        color: blackColor,
                      ),
                    ),
                    4.height,
                    Text(
                      _formatDate(payment.date),
                      style: AppTextStyles.regular.copyWith(
                        fontSize: 12,
                        color: txtdarkgrayColor,
                      ),
                    ),
                  ],
                ),
              ),
              // Status Badge
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(payment.status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      payment.status.toString(),
                      style: AppTextStyles.subHeading.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: _getStatusColor(payment.status),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          10.height,
          Divider(thickness: 0.5,height: 1,color: dividerColor)

        ],
      ),
    );
  }

  Color _getStatusColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.pending:
        return yellowColor;
      case PaymentStatus.complete:
        return successColor;
      case PaymentStatus.failed:
        return errorColor;
    }
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }
}

