import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/core/utils/extention.dart';
import 'package:training_plus/view/personalization/view/Personalization_5.dart';
import 'package:training_plus/view/personalization/personalization_provider.dart';
import 'package:training_plus/view/personalization/view/widget/CommonSelectableCard.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class Personalization4 extends ConsumerWidget {
  const Personalization4({super.key});

  final List<Map<String, String>> ageGroups = const [
    {"title": "Youth", "subtitle": "Under 13 Years Old"},
    {"title": "Teen", "subtitle": "13–17 Years Old"},
    {"title": "Adult", "subtitle": "18+ Years Old"},
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
              buildProgressBar(target: 4),
              CommonSizedBox(height: 20),
              Center(
                child: CommonText(
                  "Select Your Age\nGroup",
                  size: 22,
                  isBold: true,
                  textAlign: TextAlign.center,
                ),
              ),
              CommonSizedBox(height: 30),

              Expanded(
                child: ListView.separated(
                  itemCount: ageGroups.length,
                  separatorBuilder: (_, __) => CommonSizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final ageGroup = ageGroups[index];
                    final isSelected = state.ageGroup == ageGroup['title'];

                    return GestureDetector(
                      onTap: () =>
                          controller.updatePersonalization(ageGroup: ageGroup['title']),
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
                            CommonText(ageGroup['title']!,
                                size: 15, isBold: true),
                            CommonSizedBox(height: 4),
                            CommonText(ageGroup['subtitle']!,
                                size: 13, color: AppColors.textSecondary),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              CommonSizedBox(height: 24),
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
                      onTap: state.ageGroup.isNotEmpty
                          ? () =>
                              context.navigateTo(
  Personalization5())
                          : () {
                              context.showCommonSnackbar(
                                title: "Validity Error",
                                message:
                                    "Please select your age group before continuing.",
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
