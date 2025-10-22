import 'package:flutter/material.dart';
import 'package:training_plus/core/utils/helper.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class buildWorkoutCard extends StatelessWidget {
  final String level;
  final String title;
  final num time;
  final String imagePath;

  const buildWorkoutCard(this.level, this.title, this.time, this.imagePath, {super.key});
  

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(getFullImagePath(imagePath)),
          onError: (exception, stackTrace) => CommonImageErrorWidget(),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.6), Colors.transparent],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: CommonText(
                level,
                size: 10,
                color: Colors.white,
                isBold: true,
              ),
            ),
            const Spacer(),
            CommonText(title, size: 14, isBold: true, color: Colors.white),
            Row(
              children: [
                const Icon(Icons.access_time, size: 12, color: Colors.white),
                CommonSizedBox(width: 4),
                Expanded(
                  child: CommonText(
                    time.formatDuration(),
                    size: 12,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


