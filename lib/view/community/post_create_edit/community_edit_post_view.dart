import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/core/utils/extention.dart';
import 'package:training_plus/view/community/comunity_provider.dart';
import 'package:training_plus/widgets/common_widgets.dart';
class CommunityEditPostView extends ConsumerStatefulWidget {
  final String caption, id;
  final String catagory;

  const CommunityEditPostView({
    super.key,
    required this.catagory,
    required this.caption,
    required this.id,
  });

  @override
  ConsumerState<CommunityEditPostView> createState() =>
      _CommunityEditPostViewState();
}

class _CommunityEditPostViewState
    extends ConsumerState<CommunityEditPostView> {
  final TextEditingController _postController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Run only once after the widget is inserted in the tree
    Future.microtask(() {
      final controller = ref.read(communityPostEditCreateProvider.notifier);
      controller.selectSport(widget.catagory);
      _postController.text = widget.caption;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(communityPostEditCreateProvider);
    final controller = ref.read(communityPostEditCreateProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.boxBG,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.boxBG,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios_new),
        ),
        title: CommonText("Edit Post", size: 20, isBold: true),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: RefreshIndicator(
          onRefresh: () async => await controller.fetchCategories(),
          child: ListView(
            children: [
              // Post text input
              CommonTextfieldWithTitle(
                "Type your post here...",
                _postController,
                maxLine: 5,
                hintText:
                    "Share your training progress, achievement, or motivate others...",
              ),
              CommonSizedBox(height: 16),

              // Category chips
              Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: state.categories.map((tag) {
                    final isSelected = tag.name == state.sport;

                    return GestureDetector(
                      onTap: () => controller.selectSport(tag.name),
                      child: Chip(
                        backgroundColor:
                            isSelected ? AppColors.primary : Colors.white,
                        shape: StadiumBorder(
                          side: BorderSide(
                            width: 1.5,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                        ),
                        label: CommonText(
                          tag.name,
                          size: 13,
                          color: isSelected
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              CommonSizedBox(height: 40),

              // Share Button
              CommonButton(
                 state.isLoading ? "Updating" : "Update Post",
                onTap: () async {
                  if (_postController.text.trim().isEmpty) {
                    context.showCommonSnackbar(
                      title: "Oops",
                      message: "Please write something to share.",
                   
                    );
                    return;
                  }
                  if (state.sport == null) {
                    context.showCommonSnackbar(
                      title: "Oops",
                      message: "Please select a sport category.",
                   
                    );
                    return;
                  }

                  final result = await controller.updatePost(
                    postId: widget.id,
                    caption: _postController.text.trim(),
                    category: state.sport!,
                  );

                  if (result["title"] == "Success") {
                    controller.clearSport();
                    Navigator.pop(context);
                   context.showCommonSnackbar(
                      title: result["title"].toString(),
                      message: result["message"].toString(),
                      backgroundColor: AppColors.success,
                 
                    );
                  } else {
                    controller.clearSport();
                    context.showCommonSnackbar(
                      title: result["title"].toString(),
                      message: result["message"].toString(),
                      backgroundColor: AppColors.error,
               
                    );
                  }
                },
              ),
              CommonSizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
