
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/view/community/comunity_provider.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class CommunityEditPostView extends ConsumerStatefulWidget {
  final String caption, id, category;

  const CommunityEditPostView({
    super.key,
    required this.category,
    required this.caption,
    required this.id,
  });

  @override
  ConsumerState<CommunityEditPostView> createState() =>
      _CommunityEditPostViewState();
}

class _CommunityEditPostViewState
    extends ConsumerState<CommunityEditPostView> {
  late final TextEditingController _postController;

  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _postController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      _postController.text = widget.caption;
      final controller = ref.read(communityPostEditCreateProvider.notifier);
      controller.selectSport(widget.category); // add a helper to select by name
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _postController.dispose();
    controller.clearSport();
    super.dispose();
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
        title: commonText("Edit Post", size: 20, isBold: true),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: RefreshIndicator(
          onRefresh: () async => await controller.fetchCategories(),
          child: ListView(
            children: [
              // Post text input
              commonTextfieldWithTitle(
                "Type your post here...",
                _postController,
                maxLine: 5,
                hintText:
                    "Share your training progress, achievement, or motivate others...",
              ),
              const SizedBox(height: 16),

              // Category chips
              Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(state.categories.length, (index) {
                    final tag = state.categories[index];
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
                        label: commonText(
                          tag.name,
                          size: 13,
                          color:
                              isSelected
                                  ? AppColors.textPrimary
                                  : AppColors.textSecondary,
                        ),
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 40),

              // Share Button
              commonButton(
                state.isLoading ? "Posting..." : "Share Post",
                onTap: () async {
                  if (_postController.text.trim().isEmpty) {
                    commonSnackbar(
                      title: "Oops",
                      message: "Please write something to share.",
                      context: context,
                    );
                    return;
                  }
                  if (state.sport == null) {
                    commonSnackbar(
                      title: "Oops",
                      message: "Please select a sport category.",
                      context: context,
                    );
                    return;
                  }

                  final result = await controller.createPost(
                    caption: _postController.text.trim(),
                    category: state.sport!,
                  );

                  if (result["title"] == "Success") {
                    controller.clearSport();
                    Navigator.pop(context);
                    commonSnackbar(
                      title: result["title"].toString(),
                      message: result["message"].toString(),
                      backgroundColor: AppColors.success,
                      context: context,
                    );
                  } else {
                    controller.clearSport();

                    commonSnackbar(
                      title: result["title"].toString(),
                      message: result["message"].toString(),
                      backgroundColor: AppColors.success,
                      context: context,
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
