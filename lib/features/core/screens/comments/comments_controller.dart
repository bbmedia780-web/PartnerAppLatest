import '../../../../../../utils/library_utils.dart';

class CommentsController extends GetxController {
  var comments = <Map<String, dynamic>>[].obs;
  var commentTextController = TextEditingController();
  var isLoading = false.obs;
  var reelId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      reelId.value = arguments['reelId'] ?? '';
      _loadComments();
    }
  }

  void _loadComments() {
    // Sample comments data
    comments.value = [
      {
        'id': '1',
        'userName': 'Beauty Lover',
        'comment': 'Amazing tutorial! Thanks for sharing.',
        'time': '2 hours ago',
        'likes': 12,
        'isLiked': false,
      },
      {
        'id': '2',
        'userName': 'Salon Pro',
        'comment': 'Great technique! Will try this.',
        'time': '5 hours ago',
        'likes': 8,
        'isLiked': true,
      },
      {
        'id': '3',
        'userName': 'Makeup Artist',
        'comment': 'Love this! Can you do more tutorials?',
        'time': '1 day ago',
        'likes': 15,
        'isLiked': false,
      },
    ];
  }

  void addComment() {
    if (commentTextController.text.trim().isEmpty) return;

    final newComment = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'userName': 'You',
      'comment': commentTextController.text.trim(),
      'time': 'Just now',
      'likes': 0,
      'isLiked': false,
    };

    comments.insert(0, newComment);
    commentTextController.clear();
    
    // Return updated comments count when navigating back
    Get.back(result: {'commentsCount': comments.length});
  }

  void toggleCommentLike(int index) {
    comments[index]['isLiked'] = !(comments[index]['isLiked'] as bool);
    if (comments[index]['isLiked'] as bool) {
      comments[index]['likes'] = (comments[index]['likes'] as int) + 1;
    } else {
      comments[index]['likes'] = (comments[index]['likes'] as int) - 1;
    }
    comments.refresh();
  }

  @override
  void onClose() {
    commentTextController.dispose();
    super.onClose();
  }
}

