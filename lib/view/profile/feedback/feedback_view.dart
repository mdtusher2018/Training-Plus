import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/core/utils/extention.dart';
import 'package:training_plus/view/profile/profile_providers.dart';
import 'package:training_plus/widgets/common_sized_box.dart';
import 'package:training_plus/widgets/common_text_field_with_title.dart';
import 'package:training_plus/widgets/common_text.dart';
import 'package:training_plus/widgets/common_button.dart';

class FeedbackView extends ConsumerWidget {
   FeedbackView({super.key});

    final feedbackController = TextEditingController();


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(feedbackControllerProvider);
    final controller = ref.read(feedbackControllerProvider.notifier);


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: CommonText("Feedback", size: 21, isBold: true),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 60,
                child: FittedBox(
                  child: CommonText("How are you feeling?", isBold: true),
                ),
              ),
              CommonSizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: CommonText(
                  "Your input is valuable in helping us better understand your needs.",
                  size: 14,
                  color: AppColors.textSecondary,
                  textAlign: TextAlign.center,
                ),
              ),
              CommonSizedBox(height: 20),

              CommonText("How are we doing?", size: 18, isBold: true),
              CommonSizedBox(height: 12),

              RatingBar.builder(
                initialRating: state.rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 36,
                unratedColor: Colors.grey.shade300,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder:
                    (context, _) => const Icon(
                      Icons.star_purple500_sharp,
                      color: Colors.amber,
                    ),
                onRatingUpdate: controller.updateRating,
              ),

              CommonSizedBox(height: 24),

              CommonTextfieldWithTitle(
                "Write your answer",
                hintText: "Type your feedback here...",
                feedbackController,
                maxLine: 4,
              ),
              CommonSizedBox(height: 50),

              state.isLoading
                  ? const CircularProgressIndicator()
                  : CommonButton(
                    "Submit",
                    onTap: () async {
                      if (state.rating == 0.0 ||
                          feedbackController.text.isEmpty) {
                        context.showCommonSnackbar(
                          
                          title: "Empty",
                          message: "Please provide a rating and feedback.",
                          backgroundColor: AppColors.error,
                        );
                        return;
                      }

                      final response = await controller.submitFeedback(
                        feedbackController.text,
                      );

                  

                      if (response != null) {
                        feedbackController.clear();
                        controller.updateRating(0.0);
                        Navigator.pop(context);
                        context.showCommonSnackbar(
                          title: "Success",
                          message: "Feedback submitted successfully!",
                          backgroundColor: AppColors.success
                        );
                        return;
                      } else {
                        context.showCommonSnackbar(
                          title: "Error",
                          message: "Unknown error occoured.",
                          backgroundColor: AppColors.error,
                        );
                      }
                    },
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
