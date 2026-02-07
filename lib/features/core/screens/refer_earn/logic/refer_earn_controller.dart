import '../../../../../../utils/library_utils.dart';

class ReferEarnController extends GetxController {
  final RxString referralLink = 'https://www.flaticon.com/'.obs;
  final RxDouble totalEarned = 100.0.obs;
  final RxInt successfulReferrals = 12.obs;
  final RxDouble pendingRewards = 200.0.obs;
  final RxList<Map<String,dynamic>> lstReferralHistory =<Map<String,dynamic>>[{'name':'Riya s.','status':'Complete','amount':'100'},{'name':'Amit k.','status':'Pending','amount':'400'}].obs;
  void copyReferralLink() {
    Clipboard.setData(ClipboardData(text: referralLink.value));
    ShowToast.success('Referral link copied to clipboard');
  }

  void shareReferralLink() {
    // Implement share functionality
    ShowToast.success('Share functionality will be implemented');
  }

  void referNow() {
    Get.toNamed(AppRoutes.wallet);
  }
}

