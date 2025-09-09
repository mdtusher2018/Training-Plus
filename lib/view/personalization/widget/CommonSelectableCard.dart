import 'package:flutter/material.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class CommonSelectableCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? emoji;
  final bool isSelected;

  const CommonSelectableCard({
    super.key,
    required this.title,
    this.subtitle,
    this.emoji,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFFFFBEF) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? Colors.amber : Colors.grey.shade300,
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: subtitle == null
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (emoji != null) Text(emoji!, style: const TextStyle(fontSize: 30)),
          const SizedBox(height: 4),
          commonText(title, size: 15, isBold: true, textAlign: TextAlign.center),
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: commonText(
                subtitle!,
                size: 12,
                color: Colors.grey,
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}




  Widget buildProgressBar({required int target}) {
    return Row(
      children: List.generate(5, (index) {
        return Expanded(
          child: Container(
            height: 4,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              color: index < target ? AppColors.primary : AppColors.primary.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }

