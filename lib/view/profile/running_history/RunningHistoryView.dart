import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/core/utils/helper.dart';
import 'package:training_plus/view/profile/profile_providers.dart';
import 'package:training_plus/widgets/common_error_message.dart';
import 'package:training_plus/widgets/common_sized_box.dart';
import 'package:training_plus/widgets/common_text.dart';
import 'package:training_plus/widgets/common_image.dart';

class RunningHistoryView extends ConsumerWidget {
  const RunningHistoryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(runningHistoryControllerProvider);
    final controller = ref.read(runningHistoryControllerProvider.notifier);
    final scrollController = ref.watch(
      runningHistoryScrollControllerProvider,
    ); // << added
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
        title: CommonText("Running History", size: 21, isBold: true),
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
              return CommonErrorMassage(context: context, massage: state.error!);
            } else if (state.data == null || state.data!.results.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),

                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Center(
                      child: CommonText(
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
                separatorBuilder: (_, __) => CommonSizedBox(height: 12),
                itemBuilder: (context, index) {
                  final run = runs[index];

                  return Container(
                    padding: EdgeInsets.all(8.sp),
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
                            imagePath: run.image,

                            isAsset: run.image.isEmpty,
                            fit: BoxFit.cover,
                            width: 60,
                            height: 60,
                          ),
                        ),
                        CommonSizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: CommonText(
                                      run.place,
                                      size: 16,
                                      isBold: true,
                                      maxline: 1,
                                    ),
                                  ),
                                  CommonText(
                                    "${run.distance.toStringAsFixed(2)} Km",
                                    size: 16,
                                    isBold: true,
                                  ),
                                ],
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  CommonText(
                                    formatDuration(Duration(seconds: run.time)),
                                    size: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ],
                              ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                         Icon(
                                          Icons.access_time,
                                          size: 14.sp,
                                          color: AppColors.textPrimary,
                                        ),
                                       
                                        Flexible(
                                          child: CommonText(
                                            "${timeAgo(run.createdAt)} Ago",
                                            size: 12,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  CommonText(
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
