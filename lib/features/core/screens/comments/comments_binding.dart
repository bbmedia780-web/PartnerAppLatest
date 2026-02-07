import '../../../../../../utils/library_utils.dart';

class CommentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CommentsController());
  }
}

