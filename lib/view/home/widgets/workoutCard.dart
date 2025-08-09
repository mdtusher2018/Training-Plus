
  import 'package:flutter/material.dart';
import 'package:training_plus/widgets/common_widgets.dart';

Widget buildWorkoutCard(
      String level, String title, String time, String imagePath) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(imagePath),
          onError: (exception, stackTrace) => commonImageErrorWidget(),
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: commonText(level,
                  size: 10, color: Colors.white, isBold: true),
            ),
            const Spacer(),
            commonText(title,
                size: 14, isBold: true, color: Colors.white),
            Row(
              children: [
                const Icon(Icons.access_time,
                    size: 12, color: Colors.white),
                const SizedBox(width: 4),
                Expanded(child: commonText(time, size: 12, color: Colors.white)),
              ],
            ),
          ],
        ),
      ),
    );
  }

