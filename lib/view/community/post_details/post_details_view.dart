import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/core/utils/helper.dart';
import 'package:training_plus/view/community/comunity_provider.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class PostDetailsPage extends ConsumerWidget {
  final String postId;

  const PostDetailsPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postState = ref.watch(postDetailsProvider(postId));
    final postController = ref.read(postDetailsProvider(postId).notifier);

    if (postState.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (postState.error != null) {
      return Scaffold(
        body: Center(child: Text(postState.error!)),
      );
    }

    final post = postState.postDetails!;
    
  final likeState = ref.watch(
    postLikeControllerProvider((id: post.id, isLiked: post.isLiked, likeCount: post.likeCount)),
  );
  final likeController = ref.read(
    postLikeControllerProvider((id: post.id, isLiked: post.isLiked, likeCount: post.likeCount)).notifier,
  );



    final TextEditingController commentController = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.boxBG,
      appBar: AppBar(
        title: commonText("Post Details", size: 20, isBold: true),
        backgroundColor: AppColors.boxBG,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Post Header
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(getFullImagePath(post.postAuthor.image)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      commonText(post.postAuthor.fullName, size: 14, isBold: true),
                      commonText(timeAgo(post.createdAt), size: 12, color: AppColors.textSecondary),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.primary),
                  ),
                  child: commonText(post.category, size: 12),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Caption
            Align(
              alignment: Alignment.topLeft,
              child: commonText(post.caption, size: 14, maxline: 10)),
            const SizedBox(height: 12),

            // Likes & Comments
            Row(
              children: [
                InkWell(
                  onTap: () => likeController.toggleLike(),
                  child: Icon(
                    likeState.isLiked ? Icons.favorite : Icons.favorite_border,
                    size: 18,
                    color: likeState.isLiked ? AppColors.error : AppColors.black,
                  ),
                ),
                const SizedBox(width: 4),
                commonText(likeState.likeCount.toString(), size: 12),
                const SizedBox(width: 16),
                const Icon(Icons.mode_comment_outlined, size: 18),
                const SizedBox(width: 4),
                commonText(post.commentCount.toString(), size: 12),
              ],
            ),

            const SizedBox(height: 16),

            // Comments List
            Expanded(
              child: ListView.separated(
                itemCount: post.comments.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final comment = post.comments[index];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(getFullImagePath(comment.userImage)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                commonText(comment.userFullName, size: 14, isBold: true),
                                commonText(timeAgo(comment.createdAt), size: 12, color: AppColors.textSecondary),
                              ],
                            ),
                            const SizedBox(height: 4),
                            commonText(comment.text, size: 13, color: AppColors.textPrimary, maxline: 5),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 8),

            // Add Comment Field
      // Comment Input with Send button on top of the field
Stack(
  children: [
    // Text field
    commonTextField(
      hintText: "Type your comment here",
      controller: commentController,
      minLine: 4,
    ),

    // Send button
    Positioned(
      bottom: 10,
      right: 10,
      child: GestureDetector(
        onTap: () async {
          if (commentController.text.trim().isEmpty) return;
          
          final result = await postController.addComment(
            post.id,
            commentController.text.trim(),
          );

          commentController.clear();

          if (result["title"] == "Success") {
            commonSnackbar(
              title: result["title"]!,
              message: result["message"]!,
              context: context,
              backgroundColor: AppColors.success,
            );
          } else {
            commonSnackbar(
              title: result["title"]!,
              message: result["message"]!,
              context: context,
              backgroundColor: AppColors.error,
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              width: 1,
              color: Colors.grey.withOpacity(0.5),
            ),
          ),
          child: commonText(
            "Send",
            size: 16,
            color: AppColors.white,
          ),
        ),
      ),
    ),
  ],
),

          ],
        ),
      ),
    );
  }
}
