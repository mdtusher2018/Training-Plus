import 'package:flutter/material.dart';
import 'package:training_plus/utils/colors.dart';
import 'package:training_plus/view/personalization/Personalization_2.dart';
import 'package:training_plus/view/personalization/widget/CommonSelectableCard.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class Personalization1 extends StatelessWidget {
  Personalization1({super.key});

  final ValueNotifier<String?> selectedRole = ValueNotifier<String?>(null);

  final List<Map<String, String>> roles = [
    {
      "title": "Athlete",
      "subtitle": "Competing or training regularly",
      "emoji": "assest/images/personalization/athlete.png",
    },
    {
      "title": "Coach",
      "subtitle": "Teaching and training others",
      "emoji": "assest/images/personalization/coach.png",
    },
    {
      "title": "Parent",
      "subtitle": "Supporting my child's growth",
      "emoji": "assest/images/personalization/parent.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildProgressBar(target: 1),
              const SizedBox(height: 20),
              Center(
                child: commonText(
                  "What Describes you best?",
                  size: 22,
                  isBold: true,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),

              Expanded(
                child: ValueListenableBuilder<String?>(
                  valueListenable: selectedRole,
                  builder: (context, value, _) {
                    return ListView.separated(
                      itemCount: roles.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final role = roles[index];
                        final isSelected = value == role['title'];
                        return GestureDetector(
                          onTap: () => selectedRole.value = role['title'],
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
                            child: Row(
                              children: [
                                CommonImage(
                                  imagePath: role['emoji']!,
                                  width: 50,
                                  isAsset: true,
                                ),
                                const SizedBox(width: 14),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    commonText(role['title']!,
                                        size: 15, isBold: true),
                                    const SizedBox(height: 4),
                                    commonText(role['subtitle']!,
                                        size: 13,
                                        color: AppColors.textSecondary),
                                  ],
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
                valueListenable: selectedRole,
                builder: (context, value, _) {
                  return commonButton(
                    "Next",
                    iconWidget: const Icon(Icons.arrow_forward),
                    iconLeft: false,
                    onTap: value != null
                        ? () {
                            navigateToPage(Personalization2());
                          }
                        : () {
                            commonSnackbar(
                              title: "Validity Error",
                              message:
                                  "Please select a role before continuing.",
                              backgroundColor: AppColors.error,
                            );
                          },
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
