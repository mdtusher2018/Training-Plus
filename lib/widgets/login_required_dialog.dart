import 'package:flutter/material.dart';
import 'package:training_plus/core/utils/extention.dart';
import 'package:training_plus/view/authentication/sign_in/sign_in_view.dart';
import 'package:training_plus/widgets/common_text.dart';

Future<void> showLoginRequiredDialog({required BuildContext context}) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.lock_outline_rounded,
                size: 60,
                color: Colors.blue,
              ),

              const SizedBox(height: 16),

              const CommonText(
                "Login Required",
                size: 20,
                fontWeight: FontWeight.bold,
              ),

              const SizedBox(height: 10),

              const CommonText(
                "You are currently using guest mode. Login to access this feature and enjoy the full experience.",
                size: 15,
                textAlign: TextAlign.center,
                color: Colors.grey,
              ),

              const SizedBox(height: 20),

              Column(
                children: const [
                  _FeatureItem(text: "Sync your progress"),
                  _FeatureItem(text: "Access premium features"),
                  _FeatureItem(text: "Save your activity history"),
                ],
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const CommonText("Maybe Later", size: 10),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context.navigateTo(SigninView(), clearStack: true);
                      },
                      child: const CommonText("Login", size: 10),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _FeatureItem extends StatelessWidget {
  final String text;

  const _FeatureItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, size: 18),
          const SizedBox(width: 8),
          Expanded(child: CommonText(text, size: 14)),
        ],
      ),
    );
  }
}
