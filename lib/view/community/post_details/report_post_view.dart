import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/core/utils/extention.dart';
import 'package:training_plus/view/community/comunity_provider.dart';
import 'package:training_plus/widgets/common_button.dart';
import 'package:training_plus/widgets/common_sized_box.dart';
import 'package:training_plus/widgets/common_text.dart';

class ReportPostView extends ConsumerStatefulWidget {
  final String postId;

  const ReportPostView({super.key, required this.postId});

  @override
  ConsumerState<ReportPostView> createState() => _ReportPostViewState();
}

class _ReportPostViewState extends ConsumerState<ReportPostView> {
  String? selectedReason;
  final TextEditingController descriptionController = TextEditingController();

  final List<String> reasons = [
    "Spam",
    "Harassment or Bullying",
    "Hate Speech",
    "Inappropriate Content",
    "False Information",
    "Other",
  ];

  @override
  Widget build(BuildContext context) {
    final postController = ref.read(
      postDetailsProvider(widget.postId).notifier,
    );
    return Scaffold(
      backgroundColor: AppColors.mainBG,
      appBar: AppBar(
        title: const CommonText("Report Post", size: 20, isBold: true),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonSizedBox(height: 20),

            const CommonText(
              "Why are you reporting this post?",
              size: 16,
              isBold: true,
            ),

            const CommonSizedBox(height: 10),

            /// Reason List
            Expanded(
              child: ListView.builder(
                itemCount: reasons.length,
                itemBuilder: (context, index) {
                  final reason = reasons[index];

                  return RadioListTile<String>(
                    value: reason,
                    groupValue: selectedReason,
                    onChanged: (value) {
                      setState(() {
                        selectedReason = value;
                      });
                    },
                    title: CommonText(reason, size: 14),
                    activeColor: AppColors.primary,
                  );
                },
              ),
            ),

            const CommonText(
              "Additional Details (Optional)",
              size: 14,
              isBold: true,
            ),

            const CommonSizedBox(height: 8),

            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Provide more details...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            CommonSizedBox(height: 20),

            /// Submit Button
            CommonButton(
              "Submit Report",
              height: 45,
              isLoading: ref.watch(
                postDetailsProvider(
                  widget.postId,
                ).select((value) => value.userReportLoading),
              ),
              onTap: () async {
                if (selectedReason == null) {
                  context.showCommonSnackbar(
                    title: "Validation Error",
                    message: "Please select a reason",
                    backgroundColor: AppColors.error,
                  );

                  return;
                }
                final result = await postController.reportPost(
                  widget.postId,
                  selectedReason ?? descriptionController.text.trim(),
                );
                Navigator.pop(context);
                if (result["title"] == "Success") {
                  context.showCommonSnackbar(
                    title: result["title"]!,
                    message: result["message"]!,

                    backgroundColor: AppColors.success,
                  );
                } else {
                  context.showCommonSnackbar(
                    title: result["title"]!,
                    message: result["message"]!,

                    backgroundColor: AppColors.error,
                  );
                }
              },
            ),

            CommonSizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
