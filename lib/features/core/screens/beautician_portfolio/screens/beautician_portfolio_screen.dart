import '../../../../../../utils/library_utils.dart';

class BeauticianPortfolioScreen extends StatelessWidget {
  const BeauticianPortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<BeauticianPortfolioController>()) {
      BeauticianPortfolioBinding().dependencies();
    }
    final controller = Get.find<BeauticianPortfolioController>();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: const CustomAppBar(
        title: 'Beautician Portfolio',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Obx(() => ListView.builder(
            itemCount: controller.beauticianList.length,
            itemBuilder: (context, index) {
              final beautician = controller.beauticianList[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: BeauticianListCard(
                  beauticianName: beautician['name'] as String,
                  imagePath: beautician['image'] as String,
                  description: beautician['description'] as String,
                  onEdit: () => controller.onEditBeautician(beautician['id'] as String),
                  onTap: () => controller.onBeauticianTap(beautician['id'] as String),
                ),
              );
            },
          )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.onAddBeautician,
        backgroundColor: appColor,
        child: const Icon(
          Icons.add,
          color: whiteColor,
        ),
      ),
    );
  }
}
