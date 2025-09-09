import 'package:flutter/material.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/view/personalization/Personalization_3.dart';
import 'package:training_plus/view/personalization/widget/CommonSelectableCard.dart' show buildProgressBar;
import 'package:training_plus/widgets/common_widgets.dart';

class Personalization2 extends StatelessWidget {
  Personalization2({super.key});

  final ValueNotifier<Set<String>> selectedSports = ValueNotifier<Set<String>>({});

  final List<Map<String, String>> sportsList = [
    {"title": "Soccer", "emoji": "assest/images/personalization/soccer.png"},
    {"title": "Football", "emoji": "assest/images/personalization/football.png"},
    {"title": "Basketball", "emoji": "assest/images/personalization/basketball.png"},
    {"title": "Weight Lifting", "emoji": "assest/images/personalization/weightlifting.png"},
    {"title": "Running", "emoji": "assest/images/personalization/running.png"},
    {"title": "Yoga", "emoji": "assest/images/personalization/yoga.png"},
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
              buildProgressBar(target: 2),
              const SizedBox(height: 20),

              Center(
                child: Column(
                  children: [
                    commonText(
                      "Choose your sports",
                      size: 22,
                      isBold: true,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    commonText(
                      "Select the sports you're\ninterested in.",
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
                  valueListenable: selectedSports,
                  builder: (context, selected, _) {
                    return GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      children: sportsList.map((sport) {
                        final isSelected = selected.contains(sport['title']);
                        return GestureDetector(
                          onTap: () {
                            final updated = Set<String>.from(selected);
                            if (isSelected) {
                              updated.remove(sport['title']);
                            } else {
                              updated.add(sport['title']!);
                            }
                            selectedSports.value = updated;
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
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CommonImage(
                                  imagePath: sport['emoji']!,
                                  width: 50,
                                  isAsset: true,
                                ),
                                const SizedBox(height: 16),
                                commonText(
                                  sport['title']!,
                                  size: 18,
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
              Row(
                children: [
                  Expanded(
                    child: commonButton(
                      " Previous",
                      onTap: () {
                        Navigator.pop(context);
                      },
                      color: Colors.transparent,
                      boarder: Border.all(width: 1),
                      iconWidget: const Icon(Icons.arrow_back),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ValueListenableBuilder<Set<String>>(
                      valueListenable: selectedSports,
                      builder: (context, selected, _) {
                        return commonButton(
                          "Next ",
                          iconWidget: const Icon(Icons.arrow_forward),
                          iconLeft: false,
                          onTap: selected.isNotEmpty
                              ? () {
                                  navigateToPage(context: context,Personalization3());
                                }
                              : () {
                                  commonSnackbar(context: context,
                                    title: "Validity Error",
                                    message:
                                        "Please select at least 1 sport before continuing.",
                                    backgroundColor: AppColors.error,
                                  );
                                },
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
