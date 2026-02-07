import '../../../../../../utils/library_utils.dart';

class ServiceIconItem extends StatelessWidget {
  final String serviceName;
  final String imagePath;
  final bool isSelected;
  final VoidCallback? onTap;

  const ServiceIconItem({
    super.key,
    required this.serviceName,
    required this.imagePath,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),border: Border.all(color: isSelected ? borderColor : borderGreyColor,width: 1),),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: onTap,
          child: Column(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                  // border: Border.all(
                  //   color: isSelected ? appColor : borderGreyColor,
                  //   width: isSelected ? 2 : 1,
                  // ),
                ),
              ),
              8.height,
              SizedBox(
                width: 80,
                child: Text(
                  serviceName,
                  style: AppTextStyles.light.copyWith(
                    fontSize: 11,
                    color: blackColor,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

