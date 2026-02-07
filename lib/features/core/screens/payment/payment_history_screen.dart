import '../../../../../utils/library_utils.dart';
class PaymentHistoryScreen extends StatelessWidget {
  const PaymentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<PaymentController>()) {
      PaymentBinding().dependencies();
    }
    final controller = Get.find<PaymentController>();
    final searchController = TextEditingController();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: CustomAppBar(
        title: 'Payment History',
        isBack: false,
        children: [
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const PaymentFilterBottomSheet(),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 10, 12),
                child: Image.asset(AppImages.filterIcon,color: whiteColor,),
              )
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(12),
              child: CustomTextField(
                controller: searchController,
                labelName: '',
                hintText: 'Search here...',
                prefixIcon: SizedBox(
                  height: 20,width: 20,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Image.asset(AppImages.searchIcon,color: kColorGray,),
                  ),),
                filled: true,
                fillColor: fillColor,
                showBorder: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                onChange: (value) => controller.updateSearchQuery(value),
              ),
            ),
            // Payment List
            Expanded(
              child: Obx(() {
                final groupedPayments = controller.getGroupedPayments();
                
                if (groupedPayments.isEmpty) {
                  return Center(
                    child: Text(
                      'No payments found',
                      style: AppTextStyles.regular.copyWith(
                        color: txtdarkgrayColor,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: groupedPayments.length,
                  itemBuilder: (context, index) {
                    final dateKey = groupedPayments.keys.elementAt(index);
                    final payments = groupedPayments[dateKey]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date Header
                        Padding(
                          padding: const EdgeInsets.only(top: 16, bottom: 12),
                          child: Text(
                            dateKey,
                            style: AppTextStyles.subHeading.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: blackColor,
                            ),
                          ),
                        ),
                        // Payment Items
                        ...payments.map((payment) => PaymentListItem(payment: payment)),
                      ],
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

