import 'package:varnika_app/features/core/screens/booking/models/booking_model.dart';

import '../../../../../../utils/library_utils.dart';

class BookingController extends GetxController {
  final RxList<BookingModel> allBookings = <BookingModel>[].obs;
  final RxList<BookingModel> requestBookings = <BookingModel>[].obs;
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(DateTime.now());
  final RxString searchQuery = ''.obs;
  final Rx<BookingTab> selectedTab = BookingTab.total.obs;
  RxInt currentTab = 0.obs;
  RxList<BookingModel> bookings = <BookingModel>[
    BookingModel(
      id: '123456781',
      serviceProviderName: 'Juhi Still',
      serviceProviderImage: AppImages.img1,
      serviceName: 'Hair cutting',
      serviceType: 'Home Service',
      price: '₹12.00',
      date: DateTime(2025, 7, 22),
      status: BookingStatus.pending,
    ),

    BookingModel(
      id: '123456781',
      serviceProviderName: 'Juhi Still',
      serviceProviderImage: AppImages.img1,
      serviceName: 'Hair cutting',
      serviceType: 'Home Service',
      price: '₹12.00',
      date: DateTime(2025, 7, 22),
      status: BookingStatus.pending,
    ),
  ].obs;

  void changeTab(int index) {
    currentTab.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
    selectedDate.value = DateTime.now();
  }

  void _loadInitialData() {
    // Sample data - Replace with actual API call
    allBookings.value = [
      BookingModel(
        id: '123456781',
        serviceProviderName: 'Juhi Still',
        serviceProviderImage: AppImages.img1,
        serviceName: 'Hair cutting',
        serviceType: 'Home Service',
        price: '₹12.00',
        date: DateTime(2025, 7, 22),
        status: BookingStatus.pending,
      ),
      BookingModel(
        id: '123456782',
        serviceProviderName: 'Pari Jani',
        serviceProviderImage: AppImages.img3,
        serviceName: 'Bride Makeup',
        serviceType: 'Home Service',
        price: '₹19.00',
        date: DateTime(2025, 7, 22),
        status: BookingStatus.pending,
      ),
      BookingModel(
        id: '123456783',
        serviceProviderName: 'Jully Joshi',
        serviceProviderImage: AppImages.img2,
        serviceName: 'Pedicure',
        serviceType: 'Parlour Service',
        price: '₹17.00',
        date: DateTime(2025, 7, 22),
        status: BookingStatus.pending,
      ),
      BookingModel(
        id: '123456784',
        serviceProviderName: 'Pari Jani',
        serviceProviderImage: AppImages.img4,
        serviceName: 'Bride Makeup',
        serviceType: 'Parlour Service',
        price: '₹19,000',
        date: DateTime(2025, 7, 22),
        status: BookingStatus.completed,
      ),
      BookingModel(
        id: '123456785',
        serviceProviderName: 'Pari Jani',
        serviceProviderImage: AppImages.img1,
        serviceName: 'Bride Makeup',
        serviceType: 'Home Service',
        price: '₹19,000',
        date: DateTime(2025, 7, 22),
        status: BookingStatus.completed,
      ),
      BookingModel(
        id: '123456786',
        serviceProviderName: 'Juhi Still',
        serviceProviderImage: AppImages.img1,
        serviceName: 'Mehndi',
        serviceType: 'Parlour Service',
        price: '₹10.00',
        date: DateTime(2025, 7, 22),
        status: BookingStatus.approved,
      ),
    ];

    _loadRequestBookings();
  }

  void _loadRequestBookings() {
    requestBookings.value = allBookings
        .where((booking) => booking.status == BookingStatus.pending)
        .toList();
  }

  void approveBooking(String bookingId) {
    final booking = allBookings.firstWhere((b) => b.id == bookingId);
    final index = allBookings.indexWhere((b) => b.id == bookingId);

    // Update status to approved
    allBookings[index] = BookingModel(
      id: booking.id,
      serviceProviderName: booking.serviceProviderName,
      serviceProviderImage: booking.serviceProviderImage,
      serviceName: booking.serviceName,
      serviceType: booking.serviceType,
      price: booking.price,
      date: booking.date,
      status: BookingStatus.approved,
    );

    _loadRequestBookings();
    ShowToast.success('Booking approved successfully');
  }

  void declineBooking(String bookingId) {
    final booking = allBookings.firstWhere((b) => b.id == bookingId);
    final index = allBookings.indexWhere((b) => b.id == bookingId);

    // Update status to declined/cancelled
    allBookings[index] = BookingModel(
      id: booking.id,
      serviceProviderName: booking.serviceProviderName,
      serviceProviderImage: booking.serviceProviderImage,
      serviceName: booking.serviceName,
      serviceType: booking.serviceType,
      price: booking.price,
      date: booking.date,
      status: BookingStatus.cancelled,
    );

    _loadRequestBookings();

    ShowToast.success('Booking declined');
  }

  void callServiceProvider(String phoneNumber) {
    // Implement phone call functionality
    ShowToast.success('Calling $phoneNumber...');
  }

  String _formatDate(DateTime date) {
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
      'December',
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]}, ${date.year}';
  }
}

enum BookingTab { total, completed, cancelled }
