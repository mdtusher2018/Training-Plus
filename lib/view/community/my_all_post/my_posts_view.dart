import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/view/community/comunity_provider.dart';
import 'package:training_plus/view/community/widget/community_cards.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class MyPostsView extends ConsumerWidget {
  const MyPostsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myPostControllerProvider);
    final controller = ref.read(myPostControllerProvider.notifier);
    final scrollController = ref.watch(myPostScrollControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.boxBG,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.boxBG,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios_new),
        ),
        title: CommonText("My Posts", size: 20, isBold: true),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.refreshPosts();
        },
        child: Builder(
          builder: (context) {
            if (state.isLoading && state.posts.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.error != null) {
              return CommonErrorMassage(
                context: context,
                massage: state.error!,
              );
            }

            return ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.all(16),
              itemCount:
                  state.hasMore ? state.posts.length + 1 : state.posts.length,
              itemBuilder: (context, index) {
                if (index == state.posts.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final post = state.posts[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: PostCard(
                    id: post.id,
                    user: post.author.fullName,
                    caption: post.caption,
                    commentCount: post.commentCount,
                    isLikedByMe: post.isLiked,
                    likeCount: post.likeCount,
                    userImage: post.author.image,
                    time: post.createdAt, // you can format with timeAgo()
                    catagory: post.category,
                    myPost: true,

                    parentRef: ref,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
