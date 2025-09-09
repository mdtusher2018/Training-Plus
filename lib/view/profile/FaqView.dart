import 'package:flutter/material.dart';

import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class FaqView extends StatefulWidget {
  const FaqView({super.key});

  @override
  State<FaqView> createState() => _FaqViewState();
}

class _FaqViewState extends State<FaqView> {
  /// Stores all indexes of expanded tiles
  final Set<int> expandedIndexes = {};

  final List<Map<String, String>> faqList = const [
    {
      "question": "How do I reset my password?",
      "answer":
          "Go to Settings > Account > Reset Password and follow the on-screen instructions."
    },
    {
      "question": "How can I track my running history?",
      "answer":
          "You can view your running history from the 'Running History' section in the main menu."
    },
    {
      "question": "Can I share my achievements?",
      "answer":
          "Yes, you can share achievements directly to social media or with friends via the Share button."
    },
    {
      "question": "Is there a premium version?",
      "answer":
          "Yes, we offer a premium subscription with additional training programs and advanced analytics."
    },
        {
      "question": "Can I share my achievements?",
      "answer":
          "Yes, you can share achievements directly to social media or with friends via the Share button."
    },
    {
      "question": "Is there a premium version?",
      "answer":
          "Yes, we offer a premium subscription with additional training programs and advanced analytics."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.boxBG,
      appBar: AppBar(
        backgroundColor: AppColors.boxBG,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: commonText("FAQ", size: 21, isBold: true),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: faqList.length,
        itemBuilder: (context, index) {
          final faq = faqList[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                width: 2,
                color: expandedIndexes.contains(index)
                    ? AppColors.primary
                    : Colors.grey.withOpacity(0.5),
              ),
              color: AppColors.white,
            ),
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                onExpansionChanged: (expanded) {
                  setState(() {
                    if (expanded) {
                      expandedIndexes.add(index);
                    } else {
                      expandedIndexes.remove(index);
                    }
                  });
                },
                title: commonText(
                  faq["question"] ?? "",
                  size: 16,
                  isBold: true,
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: commonText(
                      faq["answer"] ?? "",
                      size: 14,
                      color: Colors.grey.shade700,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
