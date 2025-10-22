
import 'package:flutter/material.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/widgets/common_text.dart';



class CommonAuthAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CommonAuthAppBar(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.white),
        onPressed: () {},
      ),
      title: CommonText(title, size: 20, isBold: true, color: Colors.white),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
