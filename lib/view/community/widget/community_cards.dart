import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/core/utils/extention.dart';
import 'package:training_plus/core/utils/helper.dart';
import 'package:training_plus/view/community/post_like_comment_delete/post_like_comment_delete_controller.dart';
import 'package:training_plus/view/community/post_create_edit/community_edit_post_view.dart';
import 'package:training_plus/view/community/comunity_provider.dart';
import 'package:training_plus/view/community/post_details/post_details_view.dart';
import 'package:training_plus/widgets/common_sized_box.dart';
import 'package:training_plus/widgets/common_text_field.dart';
import 'package:training_plus/widgets/common_close_button.dart';
import 'package:training_plus/widgets/common_text.dart';
import 'package:training_plus/widgets/common_button.dart';
import 'package:training_plus/widgets/common_image.dart';

class challengeCard extends StatelessWidget {
  final String title;
  final num points;
  final bool isJoined;
  final int days;
  final int count;
  final num progress;
  final String createdAt;
  final Function()? onTap;

  const challengeCard({
    super.key,
    required this.title,
    required this.points,
    required this.isJoined,
    required this.days,
    required this.count,
    required this.progress,
    required this.createdAt,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonText(title, size: 14, isBold: true),
              GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isJoined ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      width: 1,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                  ),
                  child: CommonText(isJoined ? "Joined" : "Join", size: 12),
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
              CommonSizedBox(width: 4),
              Expanded(child: CommonText("$points Points", size: 12)),
            ],
          ),
          if (isJoined) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonText(
                  "Progress",
                  size: 12,
                  color: AppColors.textSecondary,
                ),
                CommonText(
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
          context.navigateTo(PostDetailsPage(postId: id));
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
                CommonSizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText(user, size: 14, isBold: true),
                      CommonText(
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
                    child: CommonText(catagory, size: 12, maxline: 1),
                  ),
                if (myPost) ...[
                  CommonSizedBox(width: 6),
                  GestureDetector(
                    onTap: () {
                      context.navigateTo(
                        CommunityEditPostView(
                          caption: caption,
                          id: id,
                          catagory: catagory,
                        ),
                      );
                    },
                    child: Icon(Icons.edit, size: 20.sp),
                  ),
                  CommonSizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      showDeletePostDialog(context, id, controller, parentRef);
                    },
                    child: Icon(Icons.delete_outline_rounded, size: 20.sp),
                  ),
                ],
              ],
            ),
            CommonSizedBox(height: 12),

            // Caption
            CommonText(caption, size: 13, maxline: 4),
            CommonSizedBox(height: 12),

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
                CommonSizedBox(width: 4),
                CommonText(state.likeCount.toString(), size: 12),
                CommonSizedBox(width: 16),
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
                      CommonSizedBox(width: 4),
                      CommonText(commentCount.toString(), size: 12),
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

class leaderboardCard extends StatelessWidget {
  final num points;
  final num index;
  final String name;
  final String image;

  const leaderboardCard({
    super.key,
    required this.points,
    required this.index,
    required this.name,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
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
                child: CommonText("${index + 1}", size: 16, isBold: true),
              ),
            ),
          CommonSizedBox(width: 8),
          CircleAvatar(
            radius: 14.sp,
            backgroundImage: NetworkImage(getFullImagePath(image)),
          ),
          CommonSizedBox(width: 12),
          Expanded(child: CommonText(name, size: 14)),
          CommonText(
            "$points\nPoints",
            size: 14,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}

Widget sectionHeader(String title, {required Function()? onTap}) {
  return Row(
    children: [
      Expanded(child: CommonText(title, size: 16, isBold: true, maxline: 1)),
      GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CommonText("See all "),
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
                  CommonSizedBox(height: 20),
                  Center(
                    child: CommonText(
                      "Challenge Details",
                      size: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  CommonSizedBox(height: 16),

                  CommonText(
                    "About This Challenge",
                    size: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  CommonSizedBox(height: 8),
                  CommonText(
                    "Improve your soccer skills with daily drills and exercises. Perfect for players of all levels looking to enhance their technique and fitness.",
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                  CommonSizedBox(height: 12),

                  CommonText("Time", size: 16, fontWeight: FontWeight.w600),
                  CommonSizedBox(height: 4),
                  CommonText("1 Week", size: 14),
                  SizedBox(height: 12),
                  CommonText("Rewards", size: 16, fontWeight: FontWeight.w600),
                  CommonSizedBox(height: 4),
                  CommonText("Achievement Badge\n200 Points", size: 14),

                  CommonSizedBox(height: 30),
                  if (isJoined)
                    CommonButton(
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
                          context.showCommonSnackbar(
                            title: response["title"]!,
                            message: response["message"]!,
                            backgroundColor: AppColors.success,
                          );
                        } else {
                          // ❌ Show error snackbar
                          context.showCommonSnackbar(
                            title: response["title"]!,
                            message: response["message"]!,
                            backgroundColor: AppColors.error,
                          );
                        }
                      },
                    ),
                ],
              ),

              Positioned(top: 0, right: 0, child: CommonCloseButton(context)),
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
  final TextEditingController commentTextEditingController =
      TextEditingController();

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
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.85,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CommonText("Comments", size: 18, isBold: true),
                      ),
                      CommonSizedBox(height: 16),
                      Expanded(
                        child: ListView.separated(
                          itemCount: state.comments.length,
                          separatorBuilder:
                              (_, __) => CommonSizedBox(height: 12),
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
                                              comment.user.fullName,
                                              size: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            CommonText(
                                              timeAgo(comment.createdAt),
                                              size: 12,
                                              color: AppColors.textSecondary,
                                            ),
                                          ],
                                        ),
                                        CommonSizedBox(height: 6),
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
                              ),
                            );
                          },
                        ),
                      ),
                      CommonSizedBox(height: 12),
                      Stack(
                        children: [
                          CommonTextField(
                            hintText: "Type your comment here",
                            controller: commentTextEditingController,
                            minLine: 4,
                          ),
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: GestureDetector(
                              onTap: () async {
                                if (commentTextEditingController.text
                                    .trim()
                                    .isEmpty) {
                                  return;
                                }

                                final result = await controller.postComment(
                                  commentTextEditingController.text,
                                  ref: ref,
                                  parentRef: parentRef,
                                );

                                if (result["title"] == "Success") {
                                  commentTextEditingController.clear();
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
                                  "Send",
                                  size: 16,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      CommonSizedBox(height: 8),
                    ],
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: CommonCloseButton(context),
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
        title: CommonText(
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
                child: CommonButton(
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
                child: CommonButton(
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
