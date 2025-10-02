import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/view/community/comunity_provider.dart';
import 'package:training_plus/view/community/widget/community_cards.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class ActiveChallengesView extends ConsumerWidget {
  const ActiveChallengesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(activeChallengeControllerProvider);
    final controller = ref.read(activeChallengeControllerProvider.notifier);
    final scrollController = ref.watch(activeChallengeScrollControllerProvider);

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
        title: commonText("Active Challenges", size: 20, isBold: true),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchActiveChallenges();
        },
        child: Builder(
          builder: (context) {
            if (state.isLoading && state.challenges.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.error != null) {
              return commonErrorMassage(
                context: context,
                massage: state.error!,
                
              );
            }

            return ListView.builder(
              controller: scrollController,
              physics: AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount:
                  state.hasMore
                      ? state.challenges.length + 1
                      : state.challenges.length,
              itemBuilder: (context, index) {
                if (index == state.challenges.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final challenge = state.challenges[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: challengeCard(
                    title: challenge.challengeName,
                    isJoined: challenge.isJoined,
                    points: challenge.point,
                    count: challenge.count,
                    days: challenge.days,
                    progress: challenge.progress,
                    createdAt: challenge.createdAt,
                    onTap: () {
                      showChallengeDetailsBottomSheet(
                        context,
                        isJoined: !challenge.isJoined,
                        ref: ref,
                        challengeId: challenge.id,
                        days: challenge.days,
                        condition: challenge.challengeName,
                      );
                    },
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
