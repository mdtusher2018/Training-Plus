import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/view/personalization/view/Personalization_4.dart';
import 'package:training_plus/view/personalization/personalization_provider.dart';
import 'package:training_plus/view/personalization/view/widget/CommonSelectableCard.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class Personalization3 extends ConsumerWidget {
  const Personalization3({super.key});

  final List<Map<String, String>> skills = const [
    {"title": "Beginner", "subtitle": "Just getting started"},
    {"title": "Intermediate", "subtitle": "Some experience and skills"},
    {"title": "Advanced", "subtitle": "Experienced and skilled"},
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
              buildProgressBar(target: 3),
              const SizedBox(height: 20),
              Center(
                child: commonText(
                  "What's your skill\nlevel?",
                  size: 22,
                  isBold: true,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),

              Expanded(
                child: ListView.separated(
                  itemCount: skills.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final skill = skills[index];
                    final isSelected = state.skillLevel == skill['title'];

                    return GestureDetector(
                      onTap: () =>
                          controller.updatePersonalization(skillLevel: skill['title']),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color.fromARGB(255, 255, 247, 224)
                              : AppColors.white,
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
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            commonText(skill['title']!,
                                size: 15, isBold: true),
                            const SizedBox(height: 4),
                            commonText(skill['subtitle']!,
                                size: 13, color: AppColors.textSecondary),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),
              Row(
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
                      onTap: state.skillLevel.isNotEmpty
                          ? () =>
                              navigateToPage(context: context,  Personalization4())
                          : () {
                              commonSnackbar(
                                context: context,
                                title: "Validity Error",
                                message:
                                    "Please select your skill level before continuing.",
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
