
import 'package:training_plus/core/utils/ApiEndpoints.dart';

String getFullImagePath(String imagePath) {
  if (imagePath.isEmpty) {
    return "https://www.themealdb.com/images/media/meals/wvpsxx1468256321.jpg";
  }
if(imagePath.contains("public")){
imagePath=  imagePath.replaceFirst("public", "");
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



String timeAgo(String timestamp) {




  DateTime? dateTime = DateTime.tryParse(timestamp);
  if (dateTime == null) {
    return 'Invalid date';
  }
  Duration difference = DateTime.now().difference(dateTime);

  if (difference.inSeconds < 60) {
    return 'Just now';
  } else if (difference.inMinutes < 60) {
    int minutes = difference.inMinutes;
    return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
  } else if (difference.inHours < 24) {
    int hours = difference.inHours;
    return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
  } else if (difference.inDays < 30) {
    int days = difference.inDays;
    return '$days ${days == 1 ? 'day' : 'days'} ago';
  } else if (difference.inDays < 365) {
    int months = (difference.inDays / 30).floor();
    return '$months ${months == 1 ? 'month' : 'months'} ago';
  } else {
    int years = (difference.inDays / 365).floor();
    return '$years ${years == 1 ? 'year' : 'years'} ago';
  }
}




  String formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String h = twoDigits(d.inHours);
    String m = twoDigits(d.inMinutes.remainder(60));
    String s = twoDigits(d.inSeconds.remainder(60));
    return "$h:$m:$s";
  }
