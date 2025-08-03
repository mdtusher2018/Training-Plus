import 'package:flutter/material.dart';
import 'package:training_plus/utils/colors.dart';
import 'package:training_plus/view/personalization/Personalization_6.dart';
import 'package:training_plus/view/personalization/widget/CommonSelectableCard.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class Personalization5 extends StatelessWidget {
  Personalization5({super.key});

  final ValueNotifier<Set<String>> selectedGoals = ValueNotifier<Set<String>>({});

  final List<Map<String, String>> goalsList = [
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBG,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildProgressBar(target: 5),
              const SizedBox(height: 20),

              Center(
                child: Column(
                  children: [
                    commonText(
                      "What are your\ngoals?",
                      size: 22,
                      isBold: true,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    commonText(
                      "What do you want to achieve?\n(select all that apply)",
                      size: 14,
                      textAlign: TextAlign.center,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              Expanded(
                child: ValueListenableBuilder<Set<String>>(
                  valueListenable: selectedGoals,
                  builder: (context, selected, _) {
                    return GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      children: goalsList.map((goal) {
                        final isSelected = selected.contains(goal['title']);
                        return GestureDetector(
                          onTap: () {
                            final updated = Set<String>.from(selected);
                            if (isSelected) {
                              updated.remove(goal['title']);
                            } else {
                              updated.add(goal['title']!);
                            }
                            selectedGoals.value = updated;
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CommonImage(
                                  imagePath: goal['emoji']!,
                                  width: 50,
                                  isAsset: true,
                                ),
                                const SizedBox(height: 16),
                                commonText(
                                  goal['title']!,
                                  size: 14,
                                  isBold: true,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),
              ValueListenableBuilder<Set<String>>(
                valueListenable: selectedGoals,
                builder: (context, selected, _) {
                  return Row(
                    children: [
                      Expanded(
                        child: commonButton(
                          " Previous",
                          onTap: () => Navigator.pop(context),
                          color: Colors.transparent,
                          boarder: Border.all(width: 1),
                          iconWidget: const Icon(Icons.arrow_back),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: commonButton(
                          "Next ",
                          iconWidget: const Icon(Icons.arrow_forward),
                          iconLeft: false,
                          onTap: selected.isNotEmpty
                              ? () => navigateToPage(Personalization6())
                              : () {
                                  commonSnackbar(
                                    title: "Validity Error",
                                    message:
                                        "Please select at least 1 sport before continuing.",
                                    backgroundColor: AppColors.error,
                                  );
                                },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
