
import 'package:flutter/material.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/widgets/common_text.dart';


class CommonErrorMassage extends StatelessWidget {
  final BuildContext context;
  final String massage;

  const CommonErrorMassage({
    super.key,
    required this.context,
    required this.massage,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: MediaQuery.of(this.context).size.height * 0.8,
          child: Center(
            child: CommonText(massage, size: 16, color: AppColors.error),
          ),
        ),
      ],
    );
  }
}
