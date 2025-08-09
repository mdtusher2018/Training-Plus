import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:training_plus/utils/colors.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class EditPostView extends StatefulWidget {
  const EditPostView({super.key});

  @override
  State<EditPostView> createState() => _EditPostViewState();
}

class _EditPostViewState extends State<EditPostView> {
  final TextEditingController _postController = TextEditingController();
  String? selectedTag;

  final List<String> tags = [
    "Soccer",
    "Basketball",
    "Yoga",
    "Running",
    "Weightlifting",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.boxBG,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.boxBG,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back_ios_new),
        ),
        title: commonText("Edit Post", size: 20, isBold: true),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Text Field
            commonTextfieldWithTitle(
              "Type your post here...",
              _postController,
              maxLine: 5,
              hintText:"Share your training progress, achievement, or motivate others...",
              ),
            const SizedBox(height: 16),

            // Tag Chips
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                children: tags.map((tag) {
                  final isSelected = selectedTag == tag;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTag = tag;
                      });
                    },
                    child: Chip(
                      backgroundColor:
                          isSelected ? AppColors.primary : Colors.white,
                      shape: StadiumBorder(
                        side: BorderSide(width: 1.5,
                            color: Colors.grey.withOpacity(0.5))
                                
                      ),
                      label: commonText(
                        tag,
                        size: 13,
                        color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const Spacer(),

            // Share Button
            commonButton("Share Post", onTap: () {
              if (_postController.text.trim().isEmpty) {
                Get.snackbar("Oops", "Please write something to share.",
                    snackPosition: SnackPosition.TOP);
                return;
              }

              // Handle post submission
              print("Posted: ${_postController.text}");
              print("Tag: $selectedTag");
              Get.back(); // Or navigate to feed
            }),
            SizedBox(height: 16,)
          ],
        ),
      ),
    );
  }
}
