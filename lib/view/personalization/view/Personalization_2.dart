import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/view/personalization/view/Personalization_3.dart';
import 'package:training_plus/view/personalization/personalization_provider.dart';
import 'package:training_plus/view/personalization/view/widget/CommonSelectableCard.dart' show buildProgressBar;
import 'package:training_plus/widgets/common_widgets.dart';

class Personalization2 extends ConsumerWidget {
  const Personalization2({super.key});

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
              buildProgressBar(target: 2),
              const SizedBox(height: 20),

              Center(
                child: Column(
                  children: [
                    commonText(
                      "Choose your sport",
                      size: 22,
                      isBold: true,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    commonText(
                      "Select the sport you're interested in.",
                      size: 14,
                      textAlign: TextAlign.center,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              /// Categories Grid
              Expanded(
                child: state.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : state.error != null
                        ? Center(child: Text('Error: ${state.error}'))
                        : state.categories.isEmpty
                            ? const Center(child: Text("No categories found"))
                            : GridView.count(
                                crossAxisCount: 2,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                children: state.categories.map((category) {
                                  // Only one sport can be selected
                                  final isSelected = state.sport!=null && state.sport == category.name;

                                  return GestureDetector(
                                    onTap: () {
                                      // Set the selected sport
                                      controller.updatePersonalization(sport: category.name,sportId: category.id);
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
                                      padding: const EdgeInsets.only(bottom: 14),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: CommonImage(
                                              imagePath: category.image,
                                              isAsset: false,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          commonText(
                                            category.name,
                                            size: 10,
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
                      onTap: state.sport!=null && state.sport!.isNotEmpty
                          ? () => navigateToPage(context: context, Personalization3())
                          : () => commonSnackbar(
                                context: context,
                                title: "Validity Error",
                                message: "Please select a sport before continuing.",
                                backgroundColor: AppColors.error,
                              ),
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
