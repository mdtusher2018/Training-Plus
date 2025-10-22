import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/view/home/Run_Details/running_details_model.dart';
import 'package:training_plus/widgets/common_sized_box.dart';
import 'package:training_plus/widgets/common_text.dart';
import 'package:training_plus/widgets/common_image.dart';

class RunDetailPage extends StatelessWidget {
  final RunningHistoryAttributes runData;

  const RunDetailPage({super.key, required this.runData});

  String _formatTime(int seconds) {
    final duration = Duration(seconds: seconds);
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final secs = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "${duration.inHours > 0 ? '${duration.inHours}:' : ''}$minutes:$secs";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBG,

      appBar: AppBar(
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios_new),
        ),
        title: CommonText("Run Details", size: 20, isBold: true),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Run Image
            if (runData.mongooId.image.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CommonImage(
                  imagePath: runData.mongooId.image,
                  width: double.infinity,
                  height: 100.h,
                  fit: BoxFit.cover,
                ),
              ),
            CommonSizedBox(height: 16),

            // Place
            CommonText(
              runData.mongooId.place,
              size: 22,
              isBold: true,
              color: AppColors.black,
            ),
            CommonSizedBox(height: 8),

            // User Info
            Row(
              children: [
                Icon(Icons.person, color: AppColors.primary),
                CommonSizedBox(width: 8),
                CommonText(runData.user.email, size: 16),
              ],
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
                    _statItem("Distance", "${runData.mongooId.distance} km"),
                    _statItem("Time", _formatTime(runData.mongooId.time)),
                    _statItem("Pace", "${runData.mongooId.pace} sec/km"),
                  ],
                ),
              ),
            ),
            CommonSizedBox(height: 16),

            // Created At
            CommonText(
              "Date: ${DateTime.parse(runData.mongooId.createdAt).toLocal().toString().split(' ')[0]}",
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
