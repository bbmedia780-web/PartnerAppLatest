import 'package:varnika_app/features/core/screens/wallet/logic/wallet_binding.dart';
import 'package:varnika_app/features/core/screens/wallet/logic/wallet_controller.dart';

import '../../../../../../utils/library_utils.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<WalletController>()) {
      WalletBinding().dependencies();
    }
    final controller = Get.find<WalletController>();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: const CustomAppBar(
        title: 'Wallet',
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Wallet Balance Card - Enhanced Design
            Padding(
              padding: const EdgeInsets.all(16),
              child: Obx(() => Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [appColor, tealDarkColor],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: appColor.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Decorative circles
                        Positioned(
                          top: -30,
                          right: -30,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: whiteColor.withValues(alpha: 0.1),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -20,
                          left: -20,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: whiteColor.withValues(alpha: 0.1),
                            ),
                          ),
                        ),
                        // Content
                        Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Total Balance',
                                        style: AppTextStyles.light.copyWith(
                                          fontSize: 14,
                                          color: whiteColor.withValues(alpha: 0.9),
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      8.height,
                                      Text(
                                        '₹${controller.walletBalance.value.toStringAsFixed(2)}',
                                        style: AppTextStyles.heading1.copyWith(
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                          color: whiteColor,
                                          letterSpacing: -1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: whiteColor.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.account_balance_wallet,
                                      color: whiteColor,
                                      size: 28,
                                    ),
                                  ),
                                ],
                              ),
                              24.height,
                              // Points Section
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: whiteColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: whiteColor.withValues(alpha: 0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: whiteColor.withValues(alpha: 0.2),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: const Icon(
                                            Icons.stars,
                                            color: whiteColor,
                                            size: 20,
                                          ),
                                        ),
                                        12.width,
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Reward Points',
                                              style: AppTextStyles.light.copyWith(
                                                fontSize: 12,
                                                color: whiteColor.withValues(alpha: 0.8),
                                              ),
                                            ),
                                            4.height,
                                            Text(
                                              '1,000',
                                              style: AppTextStyles.subHeading.copyWith(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: whiteColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () {},
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: whiteColor,
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: blackColor.withValues(alpha: 0.1),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          'Redeem',
                                          style: AppTextStyles.subHeading.copyWith(
                                            color: appColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ),

            // Quick Actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildQuickAction(
                      icon: Icons.add_circle_outline,
                      title: 'Add Money',
                      color: successColor,
                      onTap: () {},
                    ),
                  ),
                  12.width,
                  Expanded(
                    child: _buildQuickAction(
                      icon: Icons.arrow_upward,
                      title: 'Withdraw',
                      color: appColor,
                      onTap: () {},
                    ),
                  ),
                  12.width,
                  Expanded(
                    child: _buildQuickAction(
                      icon: Icons.history,
                      title: 'History',
                      color: yellowColor,
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
            14.height,

            // Transaction History Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Transaction History',
                    style: AppTextStyles.subHeading.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: blackColor,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'View All',
                      style: AppTextStyles.subHeading.copyWith(
                        fontSize: 14,
                        color: appColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            12.height,

            // Transaction List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(() => controller.transactions.isEmpty
                  ? _buildEmptyState()
                  : Column(
                      children: controller.transactions.take(5).map((transaction) {
                        return _buildTransactionCard(transaction);
                      }).toList(),
                    )),
            ),

            24.height,
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: CustomContainer(
        radius: 12,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 22,
              ),
            ),
            8.height,
            Text(
              title,
              style: AppTextStyles.regular.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: blackColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> transaction) {
    final isCredit = transaction['type'] == 'credit';
    final icon = isCredit ? Icons.arrow_downward : Icons.arrow_upward;
    final bgColor = isCredit
        ? successColor.withValues(alpha: 0.1)
        : errorColor.withValues(alpha: 0.1);
    final iconColor = isCredit ? successColor : errorColor;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CustomContainer(
        radius: 12,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              // Icon Container
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),
              16.width,
              // Transaction Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction['description'],
                      style: AppTextStyles.regular.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: blackColor,
                      ),
                    ),
                    6.height,
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 12,
                          color: greyDarkLight,
                        ),
                        4.width,
                        Text(
                          '${transaction['date']} • ${transaction['time']}',
                          style: AppTextStyles.light.copyWith(
                            fontSize: 12,
                            color: greyDarkLight,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Amount
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${isCredit ? '+' : '-'}₹${transaction['amount']}',
                    style: AppTextStyles.subHeading.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: iconColor,
                    ),
                  ),
                  4.height,
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      isCredit ? 'Credit' : 'Debit',
                      style: AppTextStyles.light.copyWith(
                        fontSize: 10,
                        color: iconColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return CustomContainer(
      radius: 12,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: greyDarkLight.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.receipt_long,
                size: 48,
                color: greyDarkLight,
              ),
            ),
            16.height,
            Text(
              'No Transactions Yet',
              style: AppTextStyles.subHeading.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: blackColor,
              ),
            ),
            8.height,
            Text(
              'Your transaction history will appear here',
              style: AppTextStyles.light.copyWith(
                fontSize: 13,
                color: greyDarkLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
