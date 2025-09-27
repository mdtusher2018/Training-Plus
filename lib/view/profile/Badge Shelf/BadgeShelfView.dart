import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/view/profile/profile_providers.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class BadgeShelfView extends ConsumerWidget {
  const BadgeShelfView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(badgeShelfProvider);
    final controller = ref.read(badgeShelfProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: commonText("Badge Shelf", size: 21, isBold: true),
      ),
     body: RefreshIndicator(
  onRefresh: () async {
    await controller.fetchBadges();
  },
  child: Builder(
    builder: (context) {
      if (state.isLoading && state.badges.isEmpty) {
        // 👉 Initial load (nothing in state yet)
        return const Center(child: CircularProgressIndicator());
      }

      if (state.error != null && state.badges.isEmpty) {
        // 👉 Error state with empty data
        return ListView(
   
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Center(
                    child: commonText(
                      state.error!,
                
                      color: AppColors.error,
                    ),
                  ),
                ),
              ],
            );
      }

      // 👉 Show badges (RefreshIndicator will show its own loader)
      return Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          physics: const AlwaysScrollableScrollPhysics(), // important for pull-to-refresh
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),
          itemCount: state.badges.length,
          itemBuilder: (context, index) {
            final badge = state.badges[index];
            return Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFFDEE),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary, width: 1),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: CommonImage(
                        imagePath: badge.badgeImage,
                        isAsset: false,
                        height: 80,
                      ),
                    ),
                  ),
                  commonSizedBox(height: 8),
                  commonText(
                    badge.badgeName,
                    size: 14,
                    isBold: true,
                    textAlign: TextAlign.center,
                  ),
                  commonSizedBox(height: 4),
                  commonText(
                    badge.description,
                    size: 12,
                    color: Colors.grey.shade800,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  ),
),

    );
  }
}
