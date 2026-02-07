import '../../../../../../utils/library_utils.dart';

class CommentsScreen extends StatelessWidget {
  const CommentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller if not already registered
    if (!Get.isRegistered<CommentsController>()) {
      CommentsBinding().dependencies();
    }
    final controller = Get.find<CommentsController>();

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: CustomAppBar(
        title: 'Comments',
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => controller.comments.isEmpty
                ? Center(
                    child: Text(
                      'No comments yet',
                      style: AppTextStyles.light.copyWith(
                        fontSize: 14,
                        color: txtdarkgrayColor,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: controller.comments.length,
                    itemBuilder: (context, index) {
                      final comment = controller.comments[index];
                      return _buildCommentItem(comment, index, controller);
                    },
                  )),
          ),
          // Comment input
          Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 8,
            ),
            decoration: BoxDecoration(
              color: whiteColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    labelName: '',
                    controller: controller.commentTextController,
                    hintText: 'Add a comment...',
                    borderRadius: 25,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: borderGreyColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: tealColor),
                    ),
                    hintTextStyle: AppTextStyles.light.copyWith(
                      fontSize: 14,
                      color: txtdarkgrayColor,
                    ),
                  ),
                ),
                12.width,
                GestureDetector(
                  onTap: controller.addComment,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: tealColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send,
                      color: whiteColor,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(
      Map<String, dynamic> comment, int index, CommentsController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: tealColor.withValues(alpha: 0.2),
            child: Text(
              (comment['userName'] as String)[0].toUpperCase(),
              style: AppTextStyles.subHeading.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: tealColor,
              ),
            ),
          ),
          12.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment['userName'] as String,
                      style: AppTextStyles.subHeading.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: blackColor,
                      ),
                    ),
                    8.width,
                    Text(
                      comment['time'] as String,
                      style: AppTextStyles.light.copyWith(
                        fontSize: 12,
                        color: txtdarkgrayColor,
                      ),
                    ),
                  ],
                ),
                4.height,
                Text(
                  comment['comment'] as String,
                  style: AppTextStyles.regular.copyWith(
                    fontSize: 14,
                    color: blackColor,
                  ),
                ),
                8.height,
                GestureDetector(
                  onTap: () => controller.toggleCommentLike(index),
                  child: Row(
                    children: [
                      Icon(
                        comment['isLiked'] as bool
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 16,
                        color: comment['isLiked'] as bool
                            ? Colors.red
                            : txtdarkgrayColor,
                      ),
                      4.width,
                      Text(
                        '${comment['likes']}',
                        style: AppTextStyles.light.copyWith(
                          fontSize: 12,
                          color: txtdarkgrayColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

