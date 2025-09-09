import 'package:flutter/material.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/view/personalization/Personalization_5.dart';
import 'package:training_plus/view/personalization/widget/CommonSelectableCard.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class Personalization4 extends StatelessWidget {
  Personalization4({super.key});

  final ValueNotifier<String?> selectedAgeGroup = ValueNotifier<String?>(null);

  final List<Map<String, String>> ageGroups = [
    {"title": "Youth", "subtitle": "Under 13 Years Old"},
    {"title": "Teen", "subtitle": "13–17 Years Old"},
    {"title": "Adult", "subtitle": "18+ Years Old"},
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
              buildProgressBar(target: 4),
              const SizedBox(height: 20),
              Center(
                child: commonText(
                  "Select Your Age\nGroup",
                  size: 22,
                  isBold: true,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),

              Expanded(
                child: ValueListenableBuilder<String?>(
                  valueListenable: selectedAgeGroup,
                  builder: (context, selected, _) {
                    return ListView.separated(
                      itemCount: ageGroups.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final role = ageGroups[index];
                        final isSelected = selected == role['title'];
                        return GestureDetector(
                          onTap: () => selectedAgeGroup.value = role['title'],
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
                                commonText(
                                  role['title']!,
                                  size: 15,
                                  isBold: true,
                                ),
                                const SizedBox(height: 4),
                                commonText(
                                  role['subtitle']!,
                                  size: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),
              ValueListenableBuilder<String?>(
                valueListenable: selectedAgeGroup,
                builder: (context, value, _) {
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
                          onTap: value != null
                              ? () => navigateToPage(context: context,Personalization5())
                              : () {
                                  commonSnackbar(context: context,
                                    title: "Validity Error",
                                    message:
                                        "Please select your age group before continuing.",
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
