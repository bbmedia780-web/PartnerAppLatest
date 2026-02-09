import '../models/service_model.dart';
import '../../../../../../utils/library_utils.dart' hide ServiceModel;

class ServiceListCard extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback onTap;

  const ServiceListCard({
    super.key,
    required this.service,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomContainer(
        radius: 12,
        isPadding: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Image
            Container(
              width: 120,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: AssetImage(service.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            12.width,
            // Service Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            service.serviceType,
                            style: AppTextStyles.subHeading.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: blackColor,
                            ),
                          ),
                        ),
                        // Status Tag
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(service.status).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            service.status,
                            style: AppTextStyles.regular.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: _getStatusColor(service.status),
                            ),
                          ),
                        ),
                      ],
                    ),
                    3.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            service.serviceName,
                            style: AppTextStyles.subHeading.copyWith(
                              fontSize: 12,
                              color:  greyLight,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.currency_rupee_outlined,color: appColor,size: 16,weight: 10,),
                            Text(
                              service.price,
                              style: AppTextStyles.subHeading.copyWith(
                                fontSize: 14,
                                color:  appColor,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    4.height,
                    Text(
                      service.description,
                      style: AppTextStyles.light.copyWith(
                        fontSize: 11,
                        color: greyDarkLight,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    return status.toLowerCase() == 'active' ? successColor : kColorGray;
  }
}

