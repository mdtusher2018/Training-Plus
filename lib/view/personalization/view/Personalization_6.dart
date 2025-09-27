import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/view/personalization/personalization_provider.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class Personalization6 extends ConsumerWidget {
  const Personalization6({super.key});

  Widget _buildCard({required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
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
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(personalizationControllerProvider);
    final controller = ref.watch(personalizationControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.mainBG,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                commonSizedBox(height: 16),
                commonText(
                  "Perfect! Let’s\nConfirm",
                  size: 22,
                  isBold: true,
                  textAlign: TextAlign.center,
                ),
                commonSizedBox(height: 8),
                commonText(
                  "You're all set!",
                  size: 20,
                  isBold: true,
                  textAlign: TextAlign.center,
                ),
                commonSizedBox(height: 8),
                commonText(
                  "Here's your personalized\ntraining profile",
                  size: 14,
                  color: AppColors.textSecondary,
                  textAlign: TextAlign.center,
                ),
                commonSizedBox(height: 24),

                // Display summary cards
             Align(
              alignment: Alignment.centerLeft,
               child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCard(title: "User Type", value: state.userType),
                  _buildCard(title: "Skill Level", value: state.skillLevel),
                  _buildCard(title: "Age Group", value: state.ageGroup),
                  _buildCard(title: "Sports", value: state.sport!),
                  _buildCard(title: "Goals", value: state.goal!),
                ],
               ),
             ),
                commonSizedBox(height: 8),

                commonText(
                  "You can change these preferences anytime",
                  size: 14,
                  color: AppColors.textSecondary,
                  textAlign: TextAlign.center,
                ),
                commonSizedBox(height: 20),

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
                    commonSizedBox(width: 10),
                    Expanded(
                      child: commonButton(
                        "Complete",isLoading: state.isLoading,
                        iconWidget: const Icon(Icons.done),
                        onTap: state.goal!=null && state.goal!.isNotEmpty
                            ? () {
                                // Complete action (maybe submit profile)
                                controller.completeProfile(context);
                              }
                            : () {
                                commonSnackbar(
                                  context: context,
                                  title: "Validity Error",
                                  message: "Please select at least 1 goal before continuing.",
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
