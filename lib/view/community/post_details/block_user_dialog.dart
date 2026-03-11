part of 'post_details_view.dart';

void _showBlockDialog(WidgetRef ref, String userId) {
  showDialog(
    context: ref.context,
    builder: (context) {
      final postController = ref.read(postDetailsProvider(userId).notifier);
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const CommonText(
          "Block User?",
          size: 18,
          isBold: true,
          textAlign: TextAlign.center,
        ),
        content: const CommonText(
          "Are you sure you want to block this user? You will no longer see their posts.",
          size: 14,
          textAlign: TextAlign.center,
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: CommonButton(
                  "Cancel",
                  color: Colors.grey.shade400,
                  textColor: Colors.black,
                  height: 40,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CommonButton(
                  "Block",
                  color: Colors.red,
                  textColor: Colors.white,
                  height: 40,
                  onTap: () async {
                    Navigator.pop(context);
                    final result = await postController.blockUser(userId);

                    if (result["title"] == "Success") {
                      context.showCommonSnackbar(
                        title: result["title"]!,
                        message: result["message"]!,

                        backgroundColor: AppColors.success,
                      );
                    } else {
                      context.showCommonSnackbar(
                        title: result["title"]!,
                        message: result["message"]!,

                        backgroundColor: AppColors.error,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}
