import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/view/profile/profile_providers.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class FeedbackView extends ConsumerWidget {
  const FeedbackView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(feedbackControllerProvider);
    final controller = ref.read(feedbackControllerProvider.notifier);
    final feedbackController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: commonText("Feedback", size: 21, isBold: true),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 60,
                child: FittedBox(
                  child: commonText("How are you feeling?", isBold: true),
                ),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: commonText(
                  "Your input is valuable in helping us better understand your needs.",
                  size: 14,
                  color: AppColors.textSecondary,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),

              commonText("How are we doing?", size: 18, isBold: true),
              const SizedBox(height: 12),

              RatingBar.builder(
                initialRating: state.rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 36,
                unratedColor: Colors.grey.shade300,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star_purple500_sharp,
                  color: Colors.amber,
                ),
                onRatingUpdate: controller.updateRating,
              ),

              const SizedBox(height: 24),

              commonTextfieldWithTitle(
                "Write your answer",
                hintText: "Type your feedback here...",
                feedbackController,
                maxLine: 4,
              ),
              const SizedBox(height: 50),

              state.isLoading
                  ? const CircularProgressIndicator()
                  : commonButton(
                      "Submit",
                      onTap: () async {
                        await controller.submitFeedback(feedbackController.text);

                        // if (state.error != null) {
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     SnackBar(content: Text(state.error!)),
                        //   );
                        // } else  {
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     const SnackBar(
                        //         content:
                        //             Text("Feedback submitted successfully!")),
                        //   );
                        //   feedbackController.clear();
                        //   controller.updateRating(0.0);
                        //   Navigator.pop(context);
                        // }
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
