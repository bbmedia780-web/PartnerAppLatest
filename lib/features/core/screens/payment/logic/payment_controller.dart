import '../../../../../model/payment_model.dart';
import '../../../../../utils/library_utils.dart';

class PaymentController extends GetxController {
  final RxList<PaymentModel> allPayments = <PaymentModel>[].obs;
  final RxList<PaymentModel> filteredPayments = <PaymentModel>[].obs;
  final RxString searchQuery = ''.obs;
  RxString paymentStatus = "".obs;
  RxString paymentMethod = "".obs;

  final paymentStatusList = [
    "All",
    "Pending",
    "Failed",
    "Complete",
  ];

  final paymentMethodList = [
    "Payment cash",
    "Payment online",
  ];
  // Filter states
  final Rx<DateTime?> fromDate = Rx<DateTime?>(null);
  final Rx<DateTime?> toDate = Rx<DateTime?>(null);
  final Rx<PaymentStatus?> selectedStatus = Rx<PaymentStatus?>(null);
  final Rx<PaymentMode?> selectedMode = Rx<PaymentMode?>(null);

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  void _loadInitialData() {
    // Sample data based on the image
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    
    allPayments.value = [
      // Today's payments
      PaymentModel(
        id: '1',
        customerName: 'Nurra Joshi',
        customerImage: AppImages.img1,
        date: today,
        status: PaymentStatus.pending,
        mode: PaymentMode.cash,
        amount: '₹500',
      ),
      PaymentModel(
        id: '2',
        customerName: 'Nurra Joshi',
        customerImage: AppImages.img2,
        date: today,
        status: PaymentStatus.complete,
        mode: PaymentMode.card,
        amount: '₹1,200',
      ),
      PaymentModel(
        id: '3',
        customerName: 'Johan Still',
        customerImage: AppImages.img3,
        date: today,
        status: PaymentStatus.pending,
        mode: PaymentMode.upi,
        amount: '₹800',
      ),
      // Yesterday's payments
      PaymentModel(
        id: '4',
        customerName: 'Nurra Joshi',
        customerImage: AppImages.img1,
        date: yesterday,
        status: PaymentStatus.failed,
        mode: PaymentMode.cash,
        amount: '₹600',
      ),
      PaymentModel(
        id: '5',
        customerName: 'Nurra Joshi',
        customerImage: AppImages.img2,
        date: yesterday,
        status: PaymentStatus.pending,
        mode: PaymentMode.card,
        amount: '₹900',
      ),
      PaymentModel(
        id: '6',
        customerName: 'Johan Still',
        customerImage: AppImages.img3,
        date: yesterday,
        status: PaymentStatus.failed,
        mode: PaymentMode.upi,
        amount: '₹1,500',
      ),
    ];

    filteredPayments.value = allPayments;
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  void setFromDate(DateTime? date) {
    fromDate.value = date;
  }

  void setToDate(DateTime? date) {
    toDate.value = date;
  }

  void setSelectedStatus(PaymentStatus? status) {
    selectedStatus.value = status;
  }

  void setSelectedMode(PaymentMode? mode) {
    selectedMode.value = mode;
  }

  void applyFilters() {
    _applyFilters();
    Get.back(); // Close bottom sheet
  }

  void clearFilters() {
    fromDate.value = null;
    toDate.value = null;
    selectedStatus.value = null;
    selectedMode.value = null;
    _applyFilters();
  }

  void _applyFilters() {
    List<PaymentModel> filtered = List.from(allPayments);

    // Filter by search query
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      filtered = filtered.where((payment) {
        return payment.customerName.toLowerCase().contains(query);
      }).toList();
    }

    // Filter by date range
    if (fromDate.value != null) {
      filtered = filtered.where((payment) {
        return payment.date.isAfter(fromDate.value!.subtract(const Duration(days: 1))) ||
            payment.date.isAtSameMomentAs(fromDate.value!);
      }).toList();
    }

    if (toDate.value != null) {
      filtered = filtered.where((payment) {
        return payment.date.isBefore(toDate.value!.add(const Duration(days: 1))) ||
            payment.date.isAtSameMomentAs(toDate.value!);
      }).toList();
    }

    // Filter by status
    if (selectedStatus.value != null) {
      filtered = filtered.where((payment) {
        return payment.status == selectedStatus.value;
      }).toList();
    }

    // Filter by mode
    if (selectedMode.value != null) {
      filtered = filtered.where((payment) {
        return payment.mode == selectedMode.value;
      }).toList();
    }

    filteredPayments.value = filtered;
  }

  Map<String, List<PaymentModel>> getGroupedPayments() {
    final Map<String, List<PaymentModel>> grouped = {};
    
    for (var payment in filteredPayments) {
      final dateKey = _getDateKey(payment.date);
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(payment);
    }

    // Sort dates in descending order
    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) {
        final dateA = _parseDateKey(a);
        final dateB = _parseDateKey(b);
        return dateB.compareTo(dateA);
      });

    final sortedMap = <String, List<PaymentModel>>{};
    for (var key in sortedKeys) {
      sortedMap[key] = grouped[key]!;
    }

    return sortedMap;
  }

  String _getDateKey(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final paymentDate = DateTime(date.year, date.month, date.day);

    if (paymentDate == today) {
      return 'Today';
    } else if (paymentDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      final weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
      final weekday = weekdays[date.weekday - 1];
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '$weekday, ${date.day} ${months[date.month - 1]}, ${date.year}';
    }
  }

  DateTime _parseDateKey(String key) {
    if (key == 'Today') {
      return DateTime.now();
    } else if (key == 'Yesterday') {
      return DateTime.now().subtract(const Duration(days: 1));
    } else {
      // Parse "Friday, 27 Jun, 2025"
      try {
        final parts = key.split(',');
        if (parts.length == 3) {
          final dayMonth = parts[1].trim().split(' ');
          final day = int.parse(dayMonth[0]);
          final monthStr = dayMonth[1];
          final year = int.parse(parts[2].trim());
          
          final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
          final month = months.indexWhere((m) => m == monthStr) + 1;
          
          return DateTime(year, month, day);
        }
      } catch (e) {
        // Error parsing
      }
      return DateTime.now();
    }
  }
}

