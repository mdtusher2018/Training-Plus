import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/core/utils/extention.dart';
import 'package:training_plus/view/personalization/view/Personalization_3.dart';
import 'package:training_plus/view/personalization/personalization_provider.dart';
import 'package:training_plus/view/personalization/view/widget/CommonSelectableCard.dart'
    show buildProgressBar;
import 'package:training_plus/widgets/common_widgets.dart';

class Personalization2 extends ConsumerWidget {
  const Personalization2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(personalizationControllerProvider);
    final controller = ref.read(personalizationControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.mainBG,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildProgressBar(target: 2),
              CommonSizedBox(height: 20),

              Center(
                child: Column(
                  children: [
                    CommonText(
                      "Choose your sport",
                      size: 22,
                      isBold: true,
                      textAlign: TextAlign.center,
                    ),
                    CommonSizedBox(height: 6),
                    CommonText(
                      "Select the sport you're interested in.",
                      size: 14,
                      textAlign: TextAlign.center,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
              CommonSizedBox(height: 30),

              /// Categories Grid
              Expanded(
                child:
                    state.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : state.error != null
                        ? CommonErrorMassage(
                          context: context,
                          massage: state.error!,
                        )
                        : state.categories.isEmpty
                        ? CommonErrorMassage(
                          context: context,
                          massage: "No categories found",
                        )
                        : GridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          children:
                              state.categories.map((category) {
                                // Only one sport can be selected
                                final isSelected =
                                    state.sport != null &&
                                    state.sport == category.name;

                                return GestureDetector(
                                  onTap: () {
                                    // Set the selected sport
                                    controller.updatePersonalization(
                                      sport: category.name,
                                      sportId: category.id,
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color:
                                          isSelected
                                              ? const Color(0xFFFFFBEF)
                                              : Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color:
                                            isSelected
                                                ? AppColors.primary
                                                : Colors.grey.shade300,
                                        width: 1.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.03),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.only(bottom: 14),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          spacing: 6.sp,
                                      children: [
                                        Expanded(
                                          child: CommonImage(
                                            imagePath: category.image,
                                            isAsset: false,
                                          ),
                                        ),
                                        
                                        CommonText(
                                          category.name,
                                          size: 14,
                                          maxline: 1,
                                          isBold: true,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
              ),

              CommonSizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: CommonButton(
                      " Previous",
                      onTap: () => Navigator.pop(context),
                      color: Colors.transparent,
                      boarder: Border.all(width: 1),
                      iconWidget: const Icon(Icons.arrow_back),
                    ),
                  ),
                  CommonSizedBox(width: 10),
                  Expanded(
                    child: CommonButton(
                      "Next ",
                      iconWidget: const Icon(Icons.arrow_forward),
                      iconLeft: false,
                      onTap:
                          state.sport != null && state.sport!.isNotEmpty
                              ? () =>context.navigateTo(
                               
                                Personalization3(),
                              )
                              : () => context.showCommonSnackbar(
                                title: "Validity Error",
                                message:
                                    "Please select a sport before continuing.",
                                backgroundColor: AppColors.error,
                              ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
