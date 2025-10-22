import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/core/utils/helper.dart';
import 'package:training_plus/view/community/comunity_provider.dart';
import 'package:training_plus/view/community/widget/community_cards.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class CommunityFeedView extends ConsumerWidget {
  const CommunityFeedView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(feedControllerProvider);
    final controller = ref.read(feedControllerProvider.notifier);
    final scrollController = ref.watch(feedScrollControllerProvider);

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
        title: CommonText("Community Feed", size: 20, isBold: true),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchFeed();
        },
        child: Builder(
          builder: (context) {
            if (state.isLoading && state.feed.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.error != null) {
              return CommonErrorMassage(
                context: context,
                massage: state.error!,
              );
            }

            return ListView.separated(
              controller: scrollController,
              padding: const EdgeInsets.all(16),
              itemCount:
                  state.hasMore ? state.feed.length + 1 : state.feed.length,
              separatorBuilder: (_, __) => CommonSizedBox(height: 12),
              itemBuilder: (context, index) {
                if (index == state.feed.length) {
                  // Show bottom loader when fetching more
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final post = state.feed[index];
                return PostCard(
                  id: post.id,
                  user: post.authorName,
                  caption: post.caption,
                  commentCount: post.commentCount,
                  isLikedByMe: post.isLiked,
                  userImage: post.authorImage,
                  likeCount: post.likeCount,
                  time: timeAgo(post.createdAt),
                  catagory: post.category,
                  parentRef: ref,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
