import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/core/utils/extention.dart';
import 'package:training_plus/view/personalization/view/Personalization_6.dart';
import 'package:training_plus/view/personalization/personalization_provider.dart';
import 'package:training_plus/view/personalization/view/widget/CommonSelectableCard.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class Personalization5 extends ConsumerWidget {
  const Personalization5({super.key});

  final List<Map<String, String>> goalsList = const [
    {"title": "Improve Skills", "emoji": "assest/images/personalization/improve skill.png"},
    {"title": "Build Strength & Fitness", "emoji": "assest/images/personalization/build strength.png"},
    {"title": "Workout Recovery", "emoji": "assest/images/personalization/workout recovery.png"},
    {"title": "Enhance Mental Toughness", "emoji": "assest/images/personalization/enhance mental toughness.png"},
    {"title": "Prepare for Tryouts", "emoji": "assest/images/personalization/prepare for tryouts.png"},
    {"title": "Have Fun&Stay Active", "emoji": "assest/images/personalization/have fun.png"},
    {"title": "Compete with Friends", "emoji": "assest/images/personalization/compete with friends.png"},
    {"title": "Track Nutrition & Eating", "emoji": "assest/images/personalization/track nutrition.png"},
  ];

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
              buildProgressBar(target: 5),
              CommonSizedBox(height: 20),

              Center(
                child: Column(
                  children: [
                    CommonText(
                      "What is your goal?",
                      size: 22,
                      isBold: true,
                      textAlign: TextAlign.center,
                    ),
                    CommonSizedBox(height: 6),
                    CommonText(
                      "Select the goal you want to achieve.",
                      size: 14,
                      textAlign: TextAlign.center,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
              CommonSizedBox(height: 30),

              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: goalsList.map((goal) {
                    final isSelected = state.goal == goal['title']; // only one goal

                    return GestureDetector(
                      onTap: () {
                        // update single selected goal
                        controller.updatePersonalization(goal: goal['title']);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFFFFBEF)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.grey.shade300,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 8,
                        ),
                        child: Column(
                          spacing: 6.sp,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: CommonImage(
                                imagePath: goal['emoji']!,
                                
                                isAsset: true,
                              ),
                            ),
                            
                            Flexible(
                              fit: FlexFit.loose,
                              child: CommonText(
                                goal['title']!,
                                size: 14,
                                maxline: 3,
                                isBold: true,
                                textAlign: TextAlign.center,
                              ),
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
                      onTap: state.goal != null
                          ? () =>context.navigateTo(
                               const Personalization6())
                          : () {
                              context.showCommonSnackbar(
                                title: "Validity Error",
                                message:
                                    "Please select a goal before continuing.",
                                backgroundColor: AppColors.error,
                              );
                            },
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
