import '../models/service_model.dart';
import '../../../../../../utils/library_utils.dart' hide ServiceModel;

class ServiceDetailsScreen extends StatelessWidget {
  const ServiceDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ServiceModel service = Get.arguments as ServiceModel;

    return Scaffold(
      backgroundColor: bgColor,
      appBar:  CustomAppBar(
        title: 'Service Details',
        children: [
          Stack(
            children: [
              IconButton(
                icon: Image.asset(
                  AppImages.notificationBellIcon,
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
                  color: whiteColor,
                ),
                onPressed: () {
                  Get.toNamed(AppRoutes.notifications);
                },
              ),
              // Positioned(
              //   right: 12,
              //   top: 12,
              //   child: Container(
              //     width: 8,
              //     height: 8,
              //     decoration: const BoxDecoration(
              //       color: appColor,
              //       shape: BoxShape.circle,
              //     ),
              //   ),
              // ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Image
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: AssetImage(service.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              // Service Information
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Lounge Name and Status
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            service.loungeName,
                            style: AppTextStyles.subHeading.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: blackColor,
                            ),
                          ),
                        ),
                        // Status Tag
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(service.status).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            service.status,
                            style: AppTextStyles.subHeading.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: _getStatusColor(service.status),
                            ),
                          ),
                        ),
                      ],
                    ),
                    8.height,
                    // Service Category
                    Text(
                      '${service.serviceType} | ${service.serviceName}',
                      style: AppTextStyles.regular.copyWith(
                        fontSize: 14,
                        color: greyDarkLight,
                      ),
                    ),
                    20.height,
                    // Location
                    Row(
                      children: [
                        SizedBox(
                            height: 18,
                            width: 18,
                            child: Image.asset(AppImages.locationIcon,color: appColor,)),
                        12.width,
                        Expanded(
                          child: Text(
                            service.address,
                            style: AppTextStyles.regular.copyWith(
                              fontSize: 13,
                              color: appColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    12.height,
                    Row(
                      children: [
                        SizedBox(
                            height: 18,
                            width: 18,
                            child: Image.asset(AppImages.calenderNewIcon)),
                        12.width,
                        Text(
                          service.workingDays,
                          style: AppTextStyles.regular.copyWith(
                            fontSize: 13,
                            color: txtdarkgrayColor,
                          ),
                        ),
                      ],
                    ),
                    12.height,
                    // Working Hours
                    Row(
                      children: [
                        SizedBox(
                            height: 18,
                            width: 18,
                            child: Image.asset(AppImages.watchIcon)),
                        12.width,
                        Text(
                          service.workingHours,
                          style: AppTextStyles.regular.copyWith(
                            fontSize: 13,
                            color: txtdarkgrayColor,
                          ),
                        ),
                      ],
                    ),
                    20.height,
                    // Description Section
                    Text(
                      'Description',
                      style: AppTextStyles.subHeading.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: blackColor,
                      ),
                    ),
                    12.height,
                    Text(
                      service.description,
                      style: AppTextStyles.regular.copyWith(
                        fontSize: 14,
                        color: greyLight,
                        height: 1.5,
                      ),
                    ),
                    20.height,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    return status.toLowerCase() == 'active' ? successColor : kColorGray;
  }
}

