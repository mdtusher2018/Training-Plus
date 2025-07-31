import 'package:flutter/material.dart';
import 'package:training_plus/utils/colors.dart';
import 'package:training_plus/view/personalization/Personalization_3.dart';
import 'package:training_plus/view/personalization/widget/CommonSelectableCard.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class Personalization2 extends StatefulWidget {
  const Personalization2({super.key});

  @override
  State<Personalization2> createState() => _Personalization2State();
}

class _Personalization2State extends State<Personalization2> {
  final List<Map<String, String>> sportsList = [
    {"title": "Soccer", "emoji": "assest/images/personalization/soccer.png"},
    {"title": "Football", "emoji": "assest/images/personalization/football.png"},
    {"title": "Basketball", "emoji": "assest/images/personalization/basketball.png"},
    {"title": "Weight Lifting", "emoji": "assest/images/personalization/weightlifting.png"},
    {"title": "Running", "emoji": "assest/images/personalization/running.png"},
    {"title": "Yoga", "emoji": "assest/images/personalization/yoga.png"},
  ];

  final Set<String> selectedSports = {};

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
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
          
                  children: sportsList.map((sport) {
                    final isSelected = selectedSports.contains(sport['title']);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedSports.remove(sport['title']);
                          } else {
                            selectedSports.add(sport['title']!);
                          }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFFFFBEF) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : Colors.grey.shade300,
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
                              imagePath:  sport['emoji']!,width: 50,
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
                ),
              ),

              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: commonButton(" Previous", onTap: () {
                      Navigator.pop(context);
                    },
                    color: Colors.transparent,
                    boarder: Border.all(width: 1),
                    iconWidget: Icon(Icons.arrow_back)
                    ),

                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: commonButton(
                      "Next ",
                      iconWidget: Icon(Icons.arrow_forward),
                      iconLeft: false,
                      onTap: selectedSports.isNotEmpty
                          ? () {
                              navigateToPage(Personalization3());
                            }
                          : null,
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
