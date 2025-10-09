import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/core/utils/helper.dart';
import 'package:training_plus/view/community/post_like_comment_delete/post_like_comment_delete_controller.dart';
import 'package:training_plus/view/community/post_create_edit/community_edit_post_view.dart';
import 'package:training_plus/view/community/comunity_provider.dart';
import 'package:training_plus/view/community/post_details/post_details_view.dart';
import 'package:training_plus/widgets/common_widgets.dart';

Widget challengeCard({
  required String title,
  required num points,
  required bool isJoined,
  required int days,
  required int count,
  required num progress,
  required String createdAt,
  required Function()? onTap,
}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 2.h,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            commonText(title, size: 14, isBold: true),
            GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isJoined ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    width: 1,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                ),
                child: commonText(isJoined ? "Joined" : "Join", size: 12),
              ),
            ),
          ],
        ),

        Row(
          children: [
            Icon(
              Icons.radio_button_checked,
              size: 16.sp,
              color: AppColors.primary,
            ),
            commonSizedBox(width: 4),
            Expanded(child: commonText("$points Points", size: 12)),
          ],
        ),
        if (isJoined) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              commonText("Progress", size: 12, color: AppColors.textSecondary),
              commonText(
                "${DateTime.now().difference(DateTime.tryParse(createdAt) ?? DateTime.now()).inDays}/$days Days",
                size: 12,
                color: AppColors.textSecondary,
              ),
            ],
          ),

          LinearProgressIndicator(
            value: progress.toDouble() / count.toDouble(),
            minHeight: 12.sp,
            borderRadius: BorderRadius.circular(16.r),
            backgroundColor: AppColors.boxBG,
            color: AppColors.primary,
          ),
        ],
      ],
    ),
  );
}

class PostCard extends ConsumerWidget {
  final String id;
  final String user;
  final String userImage;
  final String time;
  final String caption;
  final int likeCount;
  final int commentCount;
  final bool isLikedByMe;
  final String catagory;

  final bool myPost;
  final WidgetRef parentRef;

  const PostCard({
    super.key,
    required this.id,
    required this.user,
    required this.userImage,
    required this.time,
    required this.caption,
    required this.likeCount,
    required this.commentCount,
    required this.isLikedByMe,
    required this.catagory,
    this.myPost = false,
    required this.parentRef,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(
      postLikeDeleteControllerProvider((
        id: id,
        isLiked: isLikedByMe,
        likeCount: likeCount,
        commentCount: commentCount,
      )),
    );
    final controller = ref.read(
      postLikeDeleteControllerProvider((
        id: id,
        isLiked: isLikedByMe,
        likeCount: likeCount,
        commentCount: commentCount,
      )).notifier,
    );

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: InkWell(
        onTap: () {
          navigateToPage(PostDetailsPage(postId: id), context: context);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20.sp,
                  backgroundImage: NetworkImage(getFullImagePath(userImage)),
                ),
                commonSizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      commonText(user, size: 14, isBold: true),
                      commonText(
                        timeAgo(time),
                        size: 12,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
                if (!myPost)
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.sizeOf(context).width * 0.4,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.primary),
                    ),
                    child: commonText(catagory, size: 12, maxline: 1),
                  ),
                if (myPost) ...[
                  commonSizedBox(width: 6),
                  GestureDetector(
                    onTap: () {
                      navigateToPage(
                        context: context,
                        CommunityEditPostView(
                          caption: caption,
                          id: id,
                          catagory: catagory,
                        ),
                      );
                    },
                    child: Icon(Icons.edit, size: 20.sp),
                  ),
                  commonSizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      showDeletePostDialog(context, id, controller, parentRef);
                    },
                    child: Icon(Icons.delete_outline_rounded, size: 20.sp),
                  ),
                ],
              ],
            ),
            commonSizedBox(height: 12),

            // Caption
            commonText(caption, size: 13, maxline: 4),
            commonSizedBox(height: 12),

            // Like & Comment Row
            Row(
              children: [
                InkWell(
                  onTap: () => controller.toggleLike(),
                  child: Icon(
                    state.isLiked ? Icons.favorite : Icons.favorite_border,
                    size: 16.sp,
                    color: state.isLiked ? AppColors.error : AppColors.black,
                  ),
                ),
                commonSizedBox(width: 4),
                commonText(state.likeCount.toString(), size: 12),
                commonSizedBox(width: 16),
                GestureDetector(
                  onTap: () {
                    showCommentsBottomSheet(
                      context: context,
                      id: id,
                      isLikedByMe: isLikedByMe,
                      likeCount: likeCount,
                      commentCount: commentCount,
                      parentRef: parentRef,
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.mode_comment_outlined, size: 16.sp),
                      commonSizedBox(width: 4),
                      commonText(commentCount.toString(), size: 12),
                    ],
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

Widget leaderboardCard({
  required num points,
  required num index,
  required String name,
  required String image,
}) {
  // Image URLs for top 3 ranks
  final trophyImages = [
    "assest/images/community/rank_1st.png", // 🥇 1st
    "assest/images/community/rank_2nd.png", // 🥈 2nd
    "assest/images/community/rank_3rd.png", // 🥉 3rd
  ];

  return Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        if (index < 3)
          CommonImage(
            imagePath: trophyImages[index.toInt()],
            width: 32,
            isAsset: true,
            fit: BoxFit.cover,
          )
        else
          SizedBox(
            width: 32,
            child: Center(
              child: commonText("${index + 1}", size: 16, isBold: true),
            ),
          ),
        commonSizedBox(width: 8),
        CircleAvatar(
          radius: 14.sp,
          backgroundImage: NetworkImage(getFullImagePath(image)),
        ),
        commonSizedBox(width: 12),
        Expanded(child: commonText(name, size: 14)),
        commonText(
          "$points\nPoints",
          size: 14,
          fontWeight: FontWeight.w600,
          textAlign: TextAlign.left,
        ),
      ],
    ),
  );
}

Widget sectionHeader(String title, {required Function()? onTap}) {
  return Row(
    children: [
      Expanded(child: commonText(title, size: 16, isBold: true, maxline: 1)),
      GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            commonText("See all "),
            Icon(Icons.arrow_forward, size: 16.sp, color: AppColors.primary),
          ],
        ),
      ),
    ],
  );
}

void showChallengeDetailsBottomSheet(
  BuildContext context, {
  required bool isJoined,
  required WidgetRef ref,
  required challengeId,
  required days,
  required condition,
}) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: true,
    backgroundColor: AppColors.white,
    builder:
        (_) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  commonSizedBox(height: 20),
                  Center(
                    child: commonText(
                      "Challenge Details",
                      size: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  commonSizedBox(height: 16),

                  commonText(
                    "About This Challenge",
                    size: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  commonSizedBox(height: 8),
                  commonText(
                    "Improve your soccer skills with daily drills and exercises. Perfect for players of all levels looking to enhance their technique and fitness.",
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                  commonSizedBox(height: 12),

                  commonText("Time", size: 16, fontWeight: FontWeight.w600),
                  commonSizedBox(height: 4),
                  commonText("1 Week", size: 14),
                  SizedBox(height: 12),
                  commonText("Rewards", size: 16, fontWeight: FontWeight.w600),
                  commonSizedBox(height: 4),
                  commonText("Achievement Badge\n200 Points", size: 14),

                  commonSizedBox(height: 30),
                  if (isJoined)
                    commonButton(
                      "Join Challenge",
                      boarderRadious: 8,
                      onTap: () async {
                        final response = await ref
                            .read(activeChallengeControllerProvider.notifier)
                            .joinChallenge(
                              challengeId: challengeId,
                              day: days,
                              condition: condition,
                              ref: ref,
                            );
                        if (response["title"] == "Success") {
                          Navigator.of(context).pop();
                          commonSnackbar(
                            context: context,
                            title: response["title"]!,
                            message: response["message"]!,
                            backgroundColor: AppColors.success,
                          );
                        } else {
                          // ❌ Show error snackbar
                          commonSnackbar(
                            context: context,
                            title: response["title"]!,
                            message: response["message"]!,
                            backgroundColor: AppColors.error,
                          );
                        }
                      },
                    ),
                ],
              ),

              Positioned(top: 0, right: 0, child: commonCloseButton(context)),
            ],
          ),
        ),
  );
}

void showCommentsBottomSheet({
  required BuildContext context,
  required String id,
  required int likeCount,
  required int commentCount,
  required bool isLikedByMe,
  required WidgetRef parentRef,
}) {
  // Create controller once to preserve text input
  final TextEditingController _commentTextEditingController = TextEditingController();

  // Read controller once (ref.read does not rebuild)
  final controller = parentRef.read(
    postLikeDeleteControllerProvider((
      id: id,
      isLiked: isLikedByMe,
      likeCount: likeCount,
      commentCount: commentCount,
    )).notifier,
  );

  // Call API once before showing the bottom sheet
  controller.fetchCommentsByPostId();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    backgroundColor: AppColors.white,
    builder: (context) {
      return Consumer(
        builder: (context, ref, _) {
          // Watch state inside Consumer
          final state = ref.watch(
            postLikeDeleteControllerProvider((
              id: id,
              isLiked: isLikedByMe,
              likeCount: likeCount,
              commentCount: commentCount,
            )),
          );

          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.85,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: commonText("Comments", size: 18, isBold: true)),
                      commonSizedBox(height: 16),
                      Expanded(
                        child: ListView.separated(
                          itemCount: state.comments.length,
                          separatorBuilder: (_, __) => commonSizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final comment = state.comments[index];
                            return Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage: NetworkImage(
                                      getFullImagePath(comment.user.image),
                                    ),
                                  ),
                                  commonSizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            commonText(
                                              comment.user.fullName,
                                              size: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            commonText(
                                              timeAgo(comment.createdAt),
                                              size: 12,
                                              color: AppColors.textSecondary,
                                            ),
                                          ],
                                        ),
                                        commonSizedBox(height: 6),
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
                              ),
                            );
                          },
                        ),
                      ),
                      commonSizedBox(height: 12),
                      Stack(
                        children: [
                          commonTextField(
                            hintText: "Type your comment here",
                            controller: _commentTextEditingController,
                            minLine: 4,
                          ),
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: GestureDetector(
                              onTap: () async {
                                if (_commentTextEditingController.text.trim().isEmpty) return;

                                final result = await controller.postComment(
                                  _commentTextEditingController.text,
                                  ref: ref,
                                  parentRef: parentRef,
                                );

                                if (result["title"] == "Success") {
                                  _commentTextEditingController.clear();
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
                                child: commonText("Send", size: 16, color: AppColors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      commonSizedBox(height: 8),
                    ],
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: commonCloseButton(context),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}


Future<void> showDeletePostDialog(
  BuildContext context,
  String id,
  PostLikeCommentDeleteController controller,
  WidgetRef parentRef,
) async {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: commonText(
          "Do you want to delete this post?",
          size: 18,
          fontWeight: FontWeight.w500,
          textAlign: TextAlign.center,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          Row(
            children: [
              Expanded(
                child: commonButton(
                  "Cancel",
                  color: Colors.grey.shade400,
                  textColor: Colors.black,
                  height: 40,
                  width: 100,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: commonButton(
                  "Delete",
                  color: Colors.red.shade700,
                  textColor: Colors.white,
                  height: 40,
                  width: 100,
                  onTap: () {
                    controller.deletePost(postId: id, parentRef: parentRef);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}
