import 'package:varnika_app/shared/widgets/custom_appbar.dart';

import '../../../../../utils/library_utils.dart';
import '../logic/beautician_portfolio_binding.dart';
import '../logic/beautician_portfolio_controller.dart';
import '../widgets/beautician_list_card.dart';

class BeauticianListScreen extends StatefulWidget {
  const BeauticianListScreen({super.key});

  @override
  State<BeauticianListScreen> createState() => _BeauticianListScreenState();
}

class _BeauticianListScreenState extends State<BeauticianListScreen> {
  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<BeauticianPortfolioController>()) {
      BeauticianPortfolioBinding().dependencies();
    }
    final controller = Get.find<BeauticianPortfolioController>();

    return Scaffold(
      appBar: CustomAppBar(title: "Beauticians"),
      body: ListView.builder(
        itemCount: controller.beauticianList.length,
        itemBuilder: (context, index) {
          final item = controller.beauticianList[index];
          return BeauticianListCard(
            beauticianName: item['name'] as String,
            imagePath: item['image'] as String,
            description: item['description'] as String,
            onEdit: () => controller.onEditBeautician(item['id'] as String),
            onTap: () => controller.onBeauticianTap(item['id'] as String),
          );
        },
      ),
    );
  }
}
