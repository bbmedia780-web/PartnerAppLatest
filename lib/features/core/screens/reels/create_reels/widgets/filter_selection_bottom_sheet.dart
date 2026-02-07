
import '../../../../../../utils/library_utils.dart';

class FilterSelectionBottomSheet extends StatelessWidget {
  final CreateReelsController controller;
  
  const FilterSelectionBottomSheet({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      left: false,
      right: false,
      bottom: true,
      child: Container(
        height: Get.height * 0.5,
        decoration: BoxDecoration(
          color: filterBottmBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Tabs: AESTHETICS and SPECIAL EFFECTS
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  _buildTab('AESTHETICS', 0, controller),
                  16.width,
                  _buildTab('SPECIAL EFFECTS', 1, controller),
                ],
              ),
            ),

            // Filter grid
            Expanded(
              child: Obx(() {
                final selectedTab = controller.selectedFilterTab.value;
                final filters = selectedTab == 0
                    ? controller.aestheticsFilters
                    : controller.specialEffectsFilters;

                return Container(
                  color: darkBlueColor,
                  child: GridView.builder(
                    padding: EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: filters.length,
                    itemBuilder: (context, index) {
                      final filter = filters[index];

                      return Obx(() {
                        final isSelected = controller.selectedFilterIndex.value == index &&
                            controller.selectedFilterTab.value == selectedTab;

                        return GestureDetector(
                          onTap: () {
                            controller.applyFilter(index, selectedTab);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected ? appColor : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: filterBottmBg,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(6),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          // Preview image with filter applied - centered
                                          Container(
                                            width: 70,
                                            height: 70,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: whiteColor,
                                                width: 3,
                                              ),
                                              color: grey575654Color,
                                            ),
                                            child: ClipOval(
                                              child: filter['isIcon'] != null
                                                  ? Padding(
                                                      padding: EdgeInsets.all(12),
                                                      child: Image.asset(
                                                        filter['preview'] as String,
                                                        fit: BoxFit.contain,
                                                        color: whiteColor,
                                                        errorBuilder: (context, error, stackTrace) {
                                                          return Icon(
                                                            filter['icon'] as IconData? ?? Icons.filter,
                                                            color: whiteColor,
                                                            size: 30,
                                                          );
                                                        },
                                                      ),
                                                    )
                                                  : ColorFiltered(
                                                      colorFilter: _getColorFilterForFilterType(
                                                        filter['filter'] as String? ?? 'none',
                                                      ) ?? ColorFilter.srgbToLinearGamma(),
                                                      child: Image.asset(
                                                        AppImages.testImg,
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (context, error, stackTrace) {
                                                          return Container(
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              color: Colors.grey[800],
                                                            ),
                                                            child: Icon(
                                                              filter['icon'] as IconData? ?? Icons.filter,
                                                              color: whiteColor,
                                                              size: 30,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                            ),
                                          ),

                                          15.height,
                                          Text(
                                            filter['name'] as String? ?? '',
                                            style: AppTextStyles.regular.copyWith(
                                              color: whiteColor,
                                              fontSize: 11,
                                            ),
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        );
                      });
                    },
                  ),
                );
              }),
            ),
          ],
        ),
        ),
    );
  }
  
  Widget _buildTab(String label, int tabIndex, CreateReelsController controller) {
    return Obx(() {
      final isSelected = controller.selectedFilterTab.value == tabIndex;
      return GestureDetector(
        onTap: () {
          controller.selectedFilterTab.value = tabIndex;
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? whiteColor : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            label,
            style: AppTextStyles.regular.copyWith(
              color: isSelected ? whiteColor : Colors.grey[400],
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      );
    });
  }

  // Get ColorFilter for filter type (matching controller logic)
  ColorFilter? _getColorFilterForFilterType(String filterType) {
    switch (filterType) {
      case 'none':
        return null; // No filter
      
      case 'vintage':
        // Vintage filter: warm sepia tone
        return ColorFilter.matrix([
          0.9, 0.5, 0.1, 0, 0,
          0.3, 0.8, 0.1, 0, 0,
          0.2, 0.3, 0.5, 0, 0,
          0, 0, 0, 1, 0,
        ]);

      case 'bw':
        // Black and white filter
        return ColorFilter.matrix([
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0, 0, 0, 1, 0,
        ]);

      case 'warm':
        // Warm filter: increase red/yellow tones
        return ColorFilter.matrix([
          1.2, 0, 0, 0, 0,
          0, 1.1, 0, 0, 0,
          0, 0, 0.9, 0, 0,
          0, 0, 0, 1, 0,
        ]);

      case 'cool':
        // Cool filter: increase blue tones
        return ColorFilter.matrix([
          0.9, 0, 0, 0, 0,
          0, 0.9, 0, 0, 0,
          1.1, 0, 1.1, 0, 0,
          0, 0, 0, 1, 0,
        ]);

      case 'bright':
        // Bright filter: increase brightness
        return ColorFilter.matrix([
          1.2, 0, 0, 0, 20,
          0, 1.2, 0, 0, 20,
          0, 0, 1.2, 0, 20,
          0, 0, 0, 1, 0,
        ]);

      case 'sepia':
        // Sepia filter
        return ColorFilter.matrix([
          0.393, 0.769, 0.189, 0, 0,
          0.349, 0.686, 0.168, 0, 0,
          0.272, 0.534, 0.131, 0, 0,
          0, 0, 0, 1, 0,
        ]);

      case 'saturate':
        // Saturate filter: increase color saturation
        return ColorFilter.matrix([
          1.5, 0, 0, 0, 0,
          0, 1.5, 0, 0, 0,
          0, 0, 1.5, 0, 0,
          0, 0, 0, 1, 0,
        ]);

      case 'vignette':
      case 'fog':
      case 'ripple':
      case 'cloud':
      case 'party_lights':
        // These are special effects that might need custom shaders
        // For now, return a subtle effect
        return ColorFilter.matrix([
          1, 0, 0, 0, 0,
          0, 1, 0, 0, 0,
          0, 0, 1, 0, 0,
          0, 0, 0, 1, 0,
        ]);

      default:
        return null;
    }
  }
}

