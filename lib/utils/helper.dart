
import 'package:training_plus/utils/ApiEndpoints.dart';

String getFullImagePath(String imagePath) {
  if (imagePath.isEmpty) {
    return "https://www.themealdb.com/images/media/meals/wvpsxx1468256321.jpg";
  }

  if (imagePath.startsWith('http')) {
    return imagePath;
  }
  if (imagePath.startsWith('/')) {
    return '${ApiEndpoints.baseImageUrl}$imagePath';
  }
  return '${ApiEndpoints.baseImageUrl}/$imagePath';
}

// String formatEstimateTime(String estimateTime) {
//   // Case 1: Already in minutes or hours (like "25 mins", "1 hour")
//   if (!estimateTime.contains(":")) {
//     return estimateTime;
//   }
//   try {
//     // Parse HH:mm:ss format
//     final parts = estimateTime.split(":").map(int.parse).toList();
//     int hours = parts[0];
//     int minutes = parts[1];
//     if (hours > 0 && minutes > 0) {
//       return "$hours h $minutes mins";
//     } else if (hours > 0) {
//       return "$hours h";
//     } else {
//       return "$minutes mins";
//     }
//   } catch (e) {
//     // Fallback for malformed time
//     return estimateTime;
//   }
// }
