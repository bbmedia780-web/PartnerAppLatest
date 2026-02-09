import '../models/service_model.dart';
import '../../../../../../utils/library_utils.dart' hide ServiceModel;

class ServiceController extends GetxController {
  final RxList<ServiceModel> services = <ServiceModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadServices();
  }

  void _loadServices() {
    isLoading.value = true;
    // Simulate API call - Replace with actual API call
    Future.delayed(const Duration(milliseconds: 500), () {
      services.value = [
        ServiceModel(
          id: '1',
          serviceType: 'Facial',
          serviceName: 'Classic Facial',
          description: 'A clothing rental app description should highlight the convenience, cost savings, and unique fashion opportunitiesit provides ,Focus on the benefits of renting, like access todesigner wear',
          imageUrl: AppImages.img1,
          status: 'Active',
          loungeName: 'Ziva Bridal Lounge',
          address: '202, Shree Residency, Near Sarthana Jakat Naka, Surat, Gujarat 395006',
          workingDays: 'Monday to saturday',
          workingHours: '09:00 Am to 08:00 Pm',
          price:'200'
        ),
        ServiceModel(
          id: '2',
          serviceType: 'Haircut',
          serviceName: 'Premium Haircut',
          description: 'A clothing rental app description should highlight the convenience, cost savings, and unique fashion opportunitiesit provides ,Focus on the benefits of renting, like access todesigner wear',
          imageUrl: AppImages.img2,
          status: 'Active',
          loungeName: 'Ziva Bridal Lounge',
          address: '202, Shree Residency, Near Sarthana Jakat Naka, Surat, Gujarat 395006',
          workingDays: 'Monday to saturday',
          workingHours: '09:00 Am to 08:00 Pm',
            price:'350'
        ),
        ServiceModel(
          id: '3',
          serviceType: 'Spa',
          serviceName: 'Relaxing Spa',
          description: 'A clothing rental app description should highlight the convenience, cost savings, and unique fashion opportunitiesit provides ,Focus on the benefits of renting, like access todesigner wear',
          imageUrl: AppImages.img3,
          status: 'Inactive',
          loungeName: 'Ziva Bridal Lounge',
          address: '202, Shree Residency, Near Sarthana Jakat Naka, Surat, Gujarat 395006',
          workingDays: 'Monday to saturday',
          workingHours: '09:00 Am to 08:00 Pm', price:'450'

        ),
        ServiceModel(
          id: '4',
          serviceType: 'Makeup',
          serviceName: 'Bridal Makeup',
          description: 'A clothing rental app description should highlight the convenience, cost savings, and unique fashion opportunitiesit provides ,Focus on the benefits of renting, like access todesigner wear',
          imageUrl: AppImages.img4,
          status: 'Active',
          loungeName: 'Ziva Bridal Lounge',
          address: '202, Shree Residency, Near Sarthana Jakat Naka, Surat, Gujarat 395006',
          workingDays: 'Monday to saturday',
          workingHours: '09:00 Am to 08:00 Pm',
            price:'150'
        ),
      ];
      isLoading.value = false;
    });
  }

  void refreshServices() {
    _loadServices();
  }
}

