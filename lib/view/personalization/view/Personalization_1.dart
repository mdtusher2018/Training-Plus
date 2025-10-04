import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/view/personalization/view/Personalization_2.dart';
import 'package:training_plus/view/personalization/personalization_provider.dart';
import 'package:training_plus/view/personalization/view/widget/CommonSelectableCard.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class Personalization1 extends ConsumerWidget {
  const Personalization1({super.key});

  final List<Map<String, String>> roles = const [
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
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(personalizationControllerProvider);
    final controller = ref.read(personalizationControllerProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildProgressBar(target: 1),
              commonSizedBox(height: 20),
              Center(
                child: commonText(
                  "What Describes you best?",
                  size: 22,
                  isBold: true,
                  textAlign: TextAlign.center,
                ),
              ),
              commonSizedBox(height: 30),

              Expanded(
                child: ListView.separated(
                  itemCount: roles.length,
                  separatorBuilder: (_, __) => commonSizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final role = roles[index];
                    final isSelected = state.userType == role['title'];

                    return GestureDetector(
                      onTap: () =>
                          controller.updatePersonalization(userType: role['title']),
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
                            commonSizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  commonText(role['title']!,
                                      size: 15, isBold: true),
                                  commonSizedBox(height: 4),
                                  commonText(role['subtitle']!,
                                      size: 13, color: AppColors.textSecondary),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              commonSizedBox(height: 24),
              commonButton(
                "Next",
                iconWidget: const Icon(Icons.arrow_forward),
                iconLeft: false,
                onTap: state.userType.isNotEmpty
                    ? () {
                        navigateToPage(
                            context: context, const Personalization2());
                      }
                    : () {
                        commonSnackbar(
                          context: context,
                          title: "Validity Error",
                          message: "Please select a role before continuing.",
                          backgroundColor: AppColors.error,
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
