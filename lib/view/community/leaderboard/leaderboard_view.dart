import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/view/community/comunity_provider.dart';
import 'package:training_plus/view/community/widget/community_cards.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class LeaderboardView extends ConsumerWidget {
  const LeaderboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(leaderboardControllerProvider);
    final controller = ref.read(leaderboardControllerProvider.notifier);

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
        title: commonText("Leaderboard", size: 20, isBold: true),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchLeaderboard();
        },
        child: Builder(
          builder: (context) {
            if (state.leaderboard == null && state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.error != null) {
              return commonErrorMassage(
                context: context,
                massage: state.error!,
              );
            } else if (state.leaderboard != null &&
                state.leaderboard!.topUsers.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Center(
                      child: commonText(
                        "No users found.",
                        size: 16,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              );
            } else if (state.leaderboard == null) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: state.leaderboard!.topUsers.length,
              physics: AlwaysScrollableScrollPhysics(),

              itemBuilder: (context, index) {
                final user = state.leaderboard!.topUsers[index];
                return leaderboardCard(
                  index: index,
                  name: user.fullName,
                  points: user.points,
                  image: user.image,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
