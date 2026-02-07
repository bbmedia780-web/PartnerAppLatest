import '../../../../../../utils/library_utils.dart';

class WalletController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController couponController = TextEditingController();

  // Wallet balance
  final RxDouble walletBalance = 1250.0.obs;

  // Sample coupon codes
  final List<Map<String, dynamic>> availableCoupons = [
    {
      'code': 'WELCOME50',
      'discount': 50.0,
      'type': 'flat', // flat or percentage
      'description': 'Get ₹50 off on your first booking',
      'valid': true,
    },
    {
      'code': 'SAVE20',
      'discount': 20.0,
      'type': 'percentage',
      'description': 'Get 20% off on bookings above ₹500',
      'valid': true,
    },
    {
      'code': 'FESTIVAL100',
      'discount': 100.0,
      'type': 'flat',
      'description': 'Festival special - ₹100 off',
      'valid': true,
    },
  ];

  // Applied coupons
  final RxList<Map<String, dynamic>> appliedCoupons = <Map<String, dynamic>>[].obs;

  // Transaction history
  final RxList<Map<String, dynamic>> transactions = [
    {
      'id': '1',
      'type': 'credit', // credit or debit
      'amount': 100.0,
      'description': 'Referral bonus',
      'date': '2024-01-15',
      'time': '10:30 AM',
    },
    {
      'id': '2',
      'type': 'debit',
      'amount': 50.0,
      'description': 'Booking payment',
      'date': '2024-01-14',
      'time': '02:15 PM',
    },
    {
      'id': '3',
      'type': 'credit',
      'amount': 200.0,
      'description': 'Coupon applied',
      'date': '2024-01-13',
      'time': '09:45 AM',
    },
    {
      'id': '4',
      'type': 'credit',
      'amount': 150.0,
      'description': 'Referral bonus',
      'date': '2024-01-12',
      'time': '11:20 AM',
    },
  ].obs;

  @override
  void onClose() {
    couponController.dispose();
    super.onClose();
  }

  void applyCoupon() {
    if (formKey.currentState?.validate() ?? false) {
      final couponCode = couponController.text.trim().toUpperCase();
      
      // Check if coupon is already applied
      if (appliedCoupons.any((coupon) => coupon['code'] == couponCode)) {
        ShowToast.error('Coupon already applied');
        return;
      }

      // Find coupon in available coupons
      final coupon = availableCoupons.firstWhereOrNull(
        (c) => c['code'] == couponCode && c['valid'] == true,
      );

      if (coupon != null) {
        appliedCoupons.add(coupon);
        couponController.clear();
        
        // Add transaction
        transactions.insert(0, {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'type': 'credit',
          'amount': coupon['discount'],
          'description': 'Coupon applied: ${coupon['code']}',
          'date': _formatDate(DateTime.now()),
          'time': _formatTime(DateTime.now()),
        });

        // Update wallet balance
        walletBalance.value += coupon['discount'];

        ShowToast.success('Coupon applied successfully!');
      } else {
        ShowToast.error('The coupon code you entered is invalid or expired');
      }
    }
  }

  void removeCoupon(int index) {
    if (index >= 0 && index < appliedCoupons.length) {
      final coupon = appliedCoupons[index];
      
      // Remove from applied coupons
      appliedCoupons.removeAt(index);

      // Update wallet balance
      walletBalance.value -= coupon['discount'];

      // Add transaction
      transactions.insert(0, {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'type': 'debit',
        'amount': coupon['discount'],
        'description': 'Coupon removed: ${coupon['code']}',
        'date': _formatDate(DateTime.now()),
        'time': _formatTime(DateTime.now()),
      });

      ShowToast.success('Coupon removed successfully');
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(DateTime date) {
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  String? validateCoupon(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter coupon code';
    }
    if (value.length < 4) {
      return 'Coupon code must be at least 4 characters';
    }
    return null;
  }
}

