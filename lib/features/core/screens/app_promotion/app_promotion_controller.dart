import '../../../../../utils/library_utils.dart';

class AppPromotionController extends GetxController {
  var adCreditBalance = 2438.0.obs;
  var activePromotionsCount = 2.obs;
  var activeCouponsCount = 3.obs;
  var isCouponView = false.obs;
  
  // Top up credits modal
  var showTopUpModal = false.obs;
  var selectedAmount = 0.0.obs;
  var customAmountController = TextEditingController();
  var isCustomAmount = false.obs;

  // Create campaign modal
  var showCreateCampaignModal = false.obs;
  var campaignNameController = TextEditingController();
  var selectedCampaignType = ''.obs;
  var dailyBudgetController = TextEditingController(text: '₹500 per day');
  var selectedDuration = ''.obs;
  
  // Campaign types
  var campaignTypes = ['Featured store', 'Promoted reel', 'Banner ad', 'Sponsored post'].obs;
  
  // Duration options
  var durationOptions = ['1 day', '3 days', '7 days', '14 days', '30 days', 'Custom'].obs;

  void toggleView() {
    isCouponView.value = !isCouponView.value;
  }

  void onAddCredits() {
    showTopUpModal.value = true;
  }

  void closeTopUpModal() {
    showTopUpModal.value = false;
    selectedAmount.value = 0;
    customAmountController.clear();
    isCustomAmount.value = false;
  }

  void selectAmount(double amount) {
    selectedAmount.value = amount;
    isCustomAmount.value = false;
    customAmountController.clear();
  }

  void selectCustomAmount() {
    isCustomAmount.value = true;
    selectedAmount.value = 0;
  }

  void proceedTopUp() {
    final amount = isCustomAmount.value
        ? double.tryParse(customAmountController.text.replaceAll('₹', '').trim()) ?? 0
        : selectedAmount.value;

    if (amount <= 0) {
      ShowToast.error('Please select an amount');
      return;
    }

    // Add credits to balance
    adCreditBalance.value += amount;
    ShowToast.success('₹${amount.toStringAsFixed(0)} credits added successfully!');
    closeTopUpModal();
  }

  void onViewHistory() {
    ShowToast.success('History screen coming soon');
  }

  void onViewStatus() {
    ShowToast.success('Status screen coming soon');
  }

  void onAddPromotion() {
    // Reset form
    campaignNameController.clear();
    selectedCampaignType.value = '';
    dailyBudgetController.text = '₹500 per day';
    selectedDuration.value = '';
    showCreateCampaignModal.value = true;
  }

  void closeCreateCampaignModal() {
    showCreateCampaignModal.value = false;
    campaignNameController.clear();
    selectedCampaignType.value = '';
    dailyBudgetController.text = '₹500 per day';
    selectedDuration.value = '';
  }

  void selectCampaignType(String type) {
    selectedCampaignType.value = type;
  }

  void selectDuration(String duration) {
    selectedDuration.value = duration;
  }

  void createCampaign() {
    if (campaignNameController.text.trim().isEmpty) {
      ShowToast.error('Please enter campaign name');
      return;
    }
    if (selectedCampaignType.value.isEmpty) {
      ShowToast.error('Please select campaign type');
      return;
    }
    if (dailyBudgetController.text.trim().isEmpty) {
      ShowToast.error('Please enter daily budget');
      return;
    }
    if (selectedDuration.value.isEmpty) {
      ShowToast.error('Please select duration');
      return;
    }

    // Create campaign logic here
    activePromotionsCount.value++;
    ShowToast.success('Campaign created successfully!');
    closeCreateCampaignModal();
  }

  void onEditPromotion(int index) {
    ShowToast.success('Edit promotion $index');
  }

  void onPushPromotion(int index) {
    ShowToast.success('Promotion $index pushed successfully!');
  }

  void onDeactivatePromotion(int index) {
    Get.dialog(
      AlertDialog(
        title: const Text('Deactivate Promotion'),
        content: const Text('Are you sure you want to deactivate this promotion?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              activeCouponsCount.value--;
              Get.back();
              ShowToast.success('Promotion deactivated');
            },
            child: const Text('Deactivate', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  void onClose() {
    customAmountController.dispose();
    campaignNameController.dispose();
    dailyBudgetController.dispose();
    super.onClose();
  }
}
