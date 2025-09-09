import 'package:flutter/material.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class Personalization6 extends StatelessWidget {
  final String userType;
  final String skillLevel;
  final String ageGroup;
  final List<String> sports;
  final List<String> goals;

  const Personalization6({
    super.key,
    this.userType = "Athlete",
    this.skillLevel = "Intermediate",
    this.ageGroup = "Adult",
    this.sports = const ["Soccer", "Basketball"],
    this.goals = const ["Improve Skills", "Build Strength & Fitness"],
  });

  Widget _buildCard({required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              commonText(title, size: 16, isBold: true),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(width: 1.5, color: Colors.grey.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: commonText(value),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBG,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              spacing: 8,
              children: [
               
                commonText(
                  "Perfect! Let’s\nConfirm",
                  size: 22,
                  isBold: true,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                commonText(
                  "You're all set!",
                  size: 20,
                  isBold: true,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                commonText(
                  "Here's your personalized\ntraining profile",
                  size: 14,
                  color: AppColors.textSecondary,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
          
                // Display summary cards
                _buildCard(title: "User Type", value: userType),
                _buildCard(title: "Skill Level", value: skillLevel),
                _buildCard(title: "Age Group", value: ageGroup),
                _buildCard(title: "Sports", value: sports.join(", ")),
                _buildCard(title: "Goals", value: goals.join(", ")),
                const SizedBox(height: 8),
          
                commonText(
                  "You can change these preferences anytime",
                  size: 14,
                  color: AppColors.textSecondary,
                  textAlign: TextAlign.center,
                ),
        SizedBox(height: 20,),
          
                // Buttons
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
                      child: commonButton(
                        "Complete",
                        iconWidget: const Icon(Icons.done),
                        onTap: goals.isNotEmpty
                            ? () {
                                // Complete action
                              }
                            : () {
                                commonSnackbar(context: context,
                                  title: "Validity Error",
                                  message:
                                      "Please select at least 1 goal before continuing.",
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
      ),
    );
  }
}
