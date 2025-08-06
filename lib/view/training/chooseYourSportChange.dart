import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:training_plus/utils/colors.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class ChooseYourSportChangeView extends StatelessWidget {
  ChooseYourSportChangeView({super.key});

  // Changed to hold only one selected sport
  final ValueNotifier<String?> selectedSport = ValueNotifier<String?>(null);

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
      appBar: AppBar(leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(Icons.arrow_back_ios_new)),),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                child: ValueListenableBuilder<String?>(
                  valueListenable: selectedSport,
                  builder: (context, selected, _) {
                    return GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      children: sportsList.map((sport) {
                        final isSelected = selected == sport['title'];
                        return GestureDetector(
                          onTap: () {
                            // Only allow one selection
                            selectedSport.value = isSelected ? null : sport['title']!;
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
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
