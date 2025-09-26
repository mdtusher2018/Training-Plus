import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/core/utils/helper.dart';
import 'package:training_plus/view/profile/profile_providers.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class RunningHistoryView extends ConsumerWidget {
  const RunningHistoryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(runningHistoryControllerProvider);
    final controller = ref.read(runningHistoryControllerProvider.notifier);
 final scrollController = ref.watch(runningHistoryScrollControllerProvider); // << added
    return Scaffold(
      backgroundColor: AppColors.boxBG,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.boxBG,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: commonText("Running History", size: 21, isBold: true),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchHistory(); // pull to refresh
        },
        child: Builder(
          builder: (context) {
            if (state.data == null && state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.error != null) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),

                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Center(
                      child: commonText(
                        state.error!,
                        size: 16,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              );
            } else if (state.data == null || state.data!.results.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),

                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Center(
                      child: commonText(
                        "No running history found",
                        size: 16,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              );
            } else {
              final runs = state.data!.results;

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                controller: scrollController,
                itemCount: runs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final run = runs[index];

                  return Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CommonImage(
                            imagePath:
                                run.image.isNotEmpty
                                    ? getFullImagePath(run.image)
                                    : "assest/images/profile/runing_map.png",
                            isAsset: run.image.isEmpty,
                            fit: BoxFit.cover,
                            height: 60,
                            width: 60,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: commonText(
                                      run.place,
                                      size: 16,
                                      isBold: true,
                                      maxline: 1,
                                    ),
                                  ),
                                  commonText(
                                    "${run.distance.toStringAsFixed(2)} Km",
                                    size: 16,
                                    isBold: true,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  commonText(
                                    formatDuration(Duration(seconds: run.time)),
                                    size: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.access_time,
                                        size: 14,
                                        color: AppColors.textPrimary,
                                      ),
                                      const SizedBox(width: 4),
                                      commonText(
                                        "${timeAgo(run.createdAt)} Ago",
                                        size: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                    ],
                                  ),
                                  commonText(
                                    "${run.pace} min/km",
                                    size: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
