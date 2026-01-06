import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:training_plus/core/services/localstorage/storage_key.dart';
import 'package:training_plus/core/services/providers.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/core/utils/extention.dart';
import 'package:training_plus/core/utils/helper.dart';
import 'package:training_plus/view/authentication/sign_in/sign_in_view.dart';
import 'package:training_plus/view/home/home_providers.dart';
import 'package:training_plus/view/root_view.dart';
import 'package:training_plus/widgets/common_error_message.dart';
import 'package:training_plus/widgets/common_sized_box.dart';
import 'package:training_plus/widgets/common_text.dart';
import 'package:training_plus/widgets/common_image.dart';

class RunDetailPage extends ConsumerStatefulWidget {
  final String runId;
  const RunDetailPage({super.key, required this.runId});

  @override
  ConsumerState<RunDetailPage> createState() => _RunDetailPageState();
}

class _RunDetailPageState extends ConsumerState<RunDetailPage> {
  String _formatTime(int seconds) {
    final duration = Duration(seconds: seconds);
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final secs = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "${duration.inHours > 0 ? '${duration.inHours}:' : ''}$minutes:$secs";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(runShareDetailProvider.notifier).fetchRunDetail(widget.runId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(runShareDetailProvider);

    return Scaffold(
      backgroundColor: AppColors.mainBG,

      appBar: AppBar(
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () async {
            final localStorage = ref.read(localStorageProvider);
            final token = await localStorage.getString(StorageKey.token);

            if (token != null && token.isNotEmpty) {
              final decoded = decodeJwtPayload(token);
              if (decoded != null &&
                  decoded.containsKey("isLoginToken") &&
                  decoded['isLoginToken']) {
                context.navigateTo(RootView(), clearStack: true);
              } else {
                context.navigateTo(SigninView(), clearStack: true);
              }
            } else {
              context.navigateTo(const SigninView(), clearStack: true);
            }
          },
          child: const Icon(Icons.arrow_back_ios_new),
        ),
        title: CommonText("Run Details", size: 20, isBold: true),
      ),
      body:
          (state.isLoading)
              ? Center(child: CircularProgressIndicator())
              : (state.error != null)
              ? CommonErrorMassage(context: context, massage: state.error!)
              : state.runData == null
              ? CommonErrorMassage(
                context: context,
                massage: "Can not featch data refresh",
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Run Image
                    if (state.runData!.mongooId.image.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: CommonImage(
                          imagePath: state.runData!.mongooId.image,
                          width: double.infinity,
                          height: 100.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                    CommonSizedBox(height: 16),

                    // Place
                    CommonText(
                      state.runData!.mongooId.place,
                      size: 22,
                      isBold: true,
                      color: AppColors.black,
                    ),
                    CommonSizedBox(height: 8),

                    // User Info
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        children: [
                          Icon(Icons.person, color: AppColors.primary),
                          CommonSizedBox(width: 8),
                          CommonText(state.runData!.user.email, size: 16),
                        ],
                      ),
                    ),
                    CommonSizedBox(height: 16),

                    // Stats
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _statItem(
                              "Distance",
                              "${state.runData!.mongooId.distance} km",
                            ),
                            _statItem(
                              "Time",
                              _formatTime(state.runData!.mongooId.time),
                            ),
                            _statItem(
                              "Pace",
                              "${state.runData!.mongooId.pace} sec/km",
                            ),
                          ],
                        ),
                      ),
                    ),
                    CommonSizedBox(height: 16),

                    // Created At
                    CommonText(
                      "Date: ${DateTime.parse(state.runData!.mongooId.createdAt).toLocal().toString().split(' ')[0]}",
                      size: 16,
                    ),
                    CommonSizedBox(height: 16),

                    // Device IDs
                    // if (runData.deviceId.isNotEmpty)
                    //   Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       commonText("Devices Used:", size: 16, isBold: true),
                    //       commonSizedBox(height: 8),
                    //       Wrap(
                    //         spacing: 8,
                    //         children: runData.deviceId
                    //             .map((id) => Chip(
                    //                   label: Text(id),
                    //                   backgroundColor: AppColors.primary.withOpacity(0.2),
                    //                 ))
                    //             .toList(),
                    //       ),
                    //     ],
                    //   ),
                  ],
                ),
              ),
    );
  }

  Widget _statItem(String title, String value) {
    return Column(
      children: [
        CommonText(value, size: 18, isBold: true),
        CommonSizedBox(height: 4),
        CommonText(title, size: 14, color: Colors.grey),
      ],
    );
  }
}
