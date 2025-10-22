
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:training_plus/widgets/common_text.dart';



class CommonDropdown<T> extends StatelessWidget {
  final List<T> items;
  final T? value;
  final String hint;
  final void Function(T?) onChanged;
  final double? itemHeight;

  const CommonDropdown({
    super.key,
    required this.items,
    required this.value,
    required this.hint,
    required this.onChanged,
    this.itemHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade300, width: 1.w),
      ),
      child: DropdownButton<T>(
        isExpanded: true,
        underline: const SizedBox(),
        value: value,
        icon: Icon(Icons.keyboard_arrow_down_rounded, size: 20.sp),
        hint: CommonText(hint, size: 14.sp),
        borderRadius: BorderRadius.circular(8.r),
        itemHeight: itemHeight ?? 48.h,
        items:
            items.map<DropdownMenuItem<T>>((T item) {
              return DropdownMenuItem<T>(
                value: item,
                child: CommonText(item.toString(), size: 14),
              );
            }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
