
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/widgets/common_text.dart';



class CommonCheckbox extends StatelessWidget {
  final bool value;
  final Function(bool?) onChanged;
  final String label;

  const CommonCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.r),
          ),
          side: BorderSide(
            color: value ? AppColors.primary : Colors.grey,
            width: 2,
          ),
        ),
        if (label.isNotEmpty) Flexible(child: CommonText(label, size: 14)),
      ],
    );
  }
}
