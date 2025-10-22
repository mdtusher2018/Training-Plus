import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/view/progress/progress_provider.dart';
import 'package:training_plus/view/progress/widget/recent_session_card.dart';
import 'package:training_plus/widgets/common_error_message.dart';
import 'package:training_plus/widgets/common_sized_box.dart';
import 'package:training_plus/widgets/common_text.dart';

class RecentSessionsView extends ConsumerWidget {
  const RecentSessionsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(recentSessionsProvider);
    final controller = ref.read(recentSessionsProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.mainBG,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: CommonText("Recent Sessions", size: 21, isBold: true),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchRecentSessions();
        },
        child:
            state.isLoading && state.sessions.isEmpty && state.error == null
                ? const Center(child: CircularProgressIndicator())
                : state.error != null
                ? CommonErrorMassage(context: context, massage: state.error!)
                : ListView.separated(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: state.sessions.length,
                  separatorBuilder:
                      (context, index) => CommonSizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final session = state.sessions[index];
                    return RecentSessionCard(
                      title: session.workoutName,
                      subtitle:
                          "${session.watchTime} min | ${session.updatedAt.toLocal().toString().split(' ').first}",
                      tag: session.sportsname,
                      tagImageUrl:
                          session.thumbnail ??
                          "https://via.placeholder.com/100", // fallback
                      onTap: () {
                        // TODO: Navigate to session details
                      },
                    );
                  },
                ),
      ),
    );
  }
}
