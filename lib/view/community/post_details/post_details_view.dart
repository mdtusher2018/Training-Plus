import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/core/utils/extention.dart';
import 'package:training_plus/core/utils/helper.dart';
import 'package:training_plus/view/community/comunity_provider.dart';
import 'package:training_plus/widgets/common_error_message.dart';
import 'package:training_plus/widgets/common_sized_box.dart';
import 'package:training_plus/widgets/common_text_field.dart';
import 'package:training_plus/widgets/common_text.dart';

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
        title: CommonText("Post Details", size: 20, isBold: true),
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
              return CommonErrorMassage(
                context: context,
                massage: postState.error!,
              );
            }

        if (!postState.isLoading && postState.postDetails == null) {
              return CommonErrorMassage(
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
                            CommonSizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonText(
                                    post.postAuthor.fullName,
                                    size: 14,
                                    isBold: true,
                                  ),
                                  CommonText(
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
                              child: CommonText(post.category, size: 12),
                            ),
                          ],
                        ),

                        CommonSizedBox(height: 12),

                        // Caption
                        Align(
                          alignment: Alignment.topLeft,
                          child: CommonText(
                            post.caption,
                            size: 14,
                            maxline: 10,
                          ),
                        ),
                        CommonSizedBox(height: 12),

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
                            CommonSizedBox(width: 4),
                            CommonText(
                              likeState.likeCount.toString(),
                              size: 12,
                            ),
                            CommonSizedBox(width: 16),
                            Icon(Icons.mode_comment_outlined, size: 18.sp),
                            CommonSizedBox(width: 4),
                            CommonText(post.commentCount.toString(), size: 12),
                          ],
                        ),

                        CommonSizedBox(height: 16),

                        // Comments List
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: post.comments.length,
                          separatorBuilder:
                              (_, __) => CommonSizedBox(height: 12),
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
                                CommonSizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CommonText(
                                            comment.userFullName,
                                            size: 14,
                                            isBold: true,
                                          ),
                                          CommonText(
                                            timeAgo(comment.createdAt),
                                            size: 12,
                                            color: AppColors.textSecondary,
                                          ),
                                        ],
                                      ),
                                      CommonSizedBox(height: 4),
                                      CommonText(
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

                        CommonSizedBox(height: 8),

                        // Add Comment Field
                        // Comment Input with Send button on top of the field
                      ],
                    ),
                  ),

                  Stack(
                    children: [
                      // Text field
                      CommonTextField(
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
                            child: CommonText(
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
