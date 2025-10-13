import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/core/utils/extention.dart';
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
    final TextEditingController commentController = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.boxBG,
      appBar: AppBar(
        title: commonText("Post Details", size: 20, isBold: true),
        backgroundColor: AppColors.boxBG,
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 60.h,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          postController.fetchPostDetails(postId);
        },
        child: Builder(
          builder: (context) {
            if (postState.isLoading && postState.postDetails == null) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (postState.error != null) {
              return commonErrorMassage(
                context: context,
                massage: postState.error!,
              );
            }

        if (!postState.isLoading && postState.postDetails == null) {
              return commonErrorMassage(
                context: context,
                massage: "Faild to fetch post details",
              );
            }

    final post = postState.postDetails!;

    final likeState = ref.watch(
      postLikeDeleteControllerProvider((
        id: post.id,
        isLiked: post.isLiked,
        likeCount: post.likeCount,
        commentCount: post.commentCount,
      )),
    );
    final likeController = ref.read(
      postLikeDeleteControllerProvider((
        id: post.id,
        isLiked: post.isLiked,
        likeCount: post.likeCount,
        commentCount: post.commentCount,
      )).notifier,
    );


            return Padding(
              padding: EdgeInsets.all(16.sp),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        // Post Header
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20.sp,
                              backgroundImage: NetworkImage(
                                getFullImagePath(post.postAuthor.image),
                              ),
                            ),
                            commonSizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  commonText(
                                    post.postAuthor.fullName,
                                    size: 14,
                                    isBold: true,
                                  ),
                                  commonText(
                                    timeAgo(post.createdAt),
                                    size: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: AppColors.primary),
                              ),
                              child: commonText(post.category, size: 12),
                            ),
                          ],
                        ),

                        commonSizedBox(height: 12),

                        // Caption
                        Align(
                          alignment: Alignment.topLeft,
                          child: commonText(
                            post.caption,
                            size: 14,
                            maxline: 10,
                          ),
                        ),
                        commonSizedBox(height: 12),

                        // Likes & Comments
                        Row(
                          children: [
                            InkWell(
                              onTap: () => likeController.toggleLike(),
                              child: Icon(
                                likeState.isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 18.sp,
                                color:
                                    likeState.isLiked
                                        ? AppColors.error
                                        : AppColors.black,
                              ),
                            ),
                            commonSizedBox(width: 4),
                            commonText(
                              likeState.likeCount.toString(),
                              size: 12,
                            ),
                            commonSizedBox(width: 16),
                            Icon(Icons.mode_comment_outlined, size: 18.sp),
                            commonSizedBox(width: 4),
                            commonText(post.commentCount.toString(), size: 12),
                          ],
                        ),

                        commonSizedBox(height: 16),

                        // Comments List
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: post.comments.length,
                          separatorBuilder:
                              (_, __) => commonSizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final comment = post.comments[index];
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 20.sp,
                                  backgroundImage: NetworkImage(
                                    getFullImagePath(comment.userImage),
                                  ),
                                ),
                                commonSizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          commonText(
                                            comment.userFullName,
                                            size: 14,
                                            isBold: true,
                                          ),
                                          commonText(
                                            timeAgo(comment.createdAt),
                                            size: 12,
                                            color: AppColors.textSecondary,
                                          ),
                                        ],
                                      ),
                                      commonSizedBox(height: 4),
                                      commonText(
                                        comment.text,
                                        size: 13,
                                        color: AppColors.textPrimary,
                                        maxline: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),

                        commonSizedBox(height: 8),

                        // Add Comment Field
                        // Comment Input with Send button on top of the field
                      ],
                    ),
                  ),

                  Stack(
                    children: [
                      // Text field
                      commonTextField(
                        hintText: "Type your comment here",
                        controller: commentController,
                        minLine: 3,
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
                              ref: ref,
                            );

                            commentController.clear();

                            if (result["title"] == "Success") {
                             context.showCommonSnackbar(
                                title: result["title"]!,
                                message: result["message"]!,
                                
                                backgroundColor: AppColors.success,
                              );
                            } else {
                             context.showCommonSnackbar(
                                title: result["title"]!,
                                message: result["message"]!,
                                
                                backgroundColor: AppColors.error,
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                width: 1,
                                color: Colors.grey.withOpacity(0.5),
                              ),
                            ),
                            child: commonText(
                              (postState.isSending) ? "Sending..." : "Send",
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
            );
          },
        ),
      ),
    );
  }
}
