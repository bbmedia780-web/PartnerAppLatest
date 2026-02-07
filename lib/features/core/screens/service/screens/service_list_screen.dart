import '../../../../../../utils/library_utils.dart';

class ServiceListScreen extends StatelessWidget {
  const ServiceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ServiceController>()) {
      ServiceBinding().dependencies();
    }
    final controller = Get.find<ServiceController>();

    return Scaffold(
      backgroundColor: bgColor,
      appBar:  CustomAppBar(
        title: 'Service',
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
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (controller.services.isEmpty) {
            return Center(
              child: Text(
                'No services found',
                style: AppTextStyles.regular.copyWith(
                  color: txtdarkgrayColor,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.services.length,
            itemBuilder: (context, index) {
              final service = controller.services[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ServiceListCard(
                  service: service,
                  onTap: () {
                    Get.toNamed(
                      AppRoutes.serviceDetails,
                      arguments: service,
                    );
                  },
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

