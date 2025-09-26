class NutritionTrackerResponse {
  final String status;
  final num statusCode;
  final String message;
  final NutritionData data;

  NutritionTrackerResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory NutritionTrackerResponse.fromJson(Map<String, dynamic> json) {
    return NutritionTrackerResponse(
      status: json["status"] ?? "",
      statusCode: json["statusCode"] ?? 0,
      message: json["message"] ?? "",
      data: NutritionData.fromJson(json["data"]["attributes"] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "statusCode": statusCode,
      "message": message,
      "data": {"attributes": data.toJson()},
    };
  }
}

class NutritionData {
  final QuickTodayGain quickTodayGain;
  final DetailedProgress detailedProgress;
  final num overallPercent;
  final List<TodayMeal> todayMeals;

  NutritionData({
    required this.quickTodayGain,
    required this.detailedProgress,
    required this.overallPercent,
    required this.todayMeals,
  });

  factory NutritionData.fromJson(Map<String, dynamic> json) {
    return NutritionData(
      quickTodayGain: QuickTodayGain.fromJson(json["quickTodayGain"] ?? {}),
      detailedProgress: DetailedProgress.fromJson(json["detailedProgress"] ?? {}),
      overallPercent: json["overallPercent"] ?? 0,
      todayMeals: (json["todayMeals"] as List<dynamic>? ?? [])
          .map((e) => TodayMeal.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "quickTodayGain": quickTodayGain.toJson(),
      "detailedProgress": detailedProgress.toJson(),
      "overallPercent": overallPercent,
      "todayMeals": todayMeals.map((e) => e.toJson()).toList(),
    };
  }
}

class QuickTodayGain {
  final String? id;
  final num calories;
  final num proteins;
  final num carbs;
  final num fats;

  QuickTodayGain({
    this.id,
    required this.calories,
    required this.proteins,
    required this.carbs,
    required this.fats,
  });

  factory QuickTodayGain.fromJson(Map<String, dynamic> json) {
    return QuickTodayGain(
      id: json["_id"],
      calories: json["calories"] ?? 0,
      proteins: json["proteins"] ?? 0,
      carbs: json["carbs"] ?? 0,
      fats: json["fats"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "calories": calories,
      "proteins": proteins,
      "carbs": carbs,
      "fats": fats,
    };
  }
}

class DetailedProgress {
  final ProgressItem calories;
  final ProgressItem proteins;
  final ProgressItem carbs;
  final ProgressItem fats;

  DetailedProgress({
    required this.calories,
    required this.proteins,
    required this.carbs,
    required this.fats,
  });

  factory DetailedProgress.fromJson(Map<String, dynamic> json) {
    return DetailedProgress(
      calories: ProgressItem.fromJson(json["calories"] ?? {}),
      proteins: ProgressItem.fromJson(json["proteins"] ?? {}),
      carbs: ProgressItem.fromJson(json["carbs"] ?? {}),
      fats: ProgressItem.fromJson(json["fats"] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "calories": calories.toJson(),
      "proteins": proteins.toJson(),
      "carbs": carbs.toJson(),
      "fats": fats.toJson(),
    };
  }
}

class ProgressItem {
  final num goal;
  final num gain;
  final num percentage;
  final num remaining;

  ProgressItem({
    required this.goal,
    required this.gain,
    required this.percentage,
    required this.remaining,
  });

  factory ProgressItem.fromJson(Map<String, dynamic> json) {
    return ProgressItem(
      goal: json["goal"] ?? 0,
      gain: json["gain"] ?? 0,
      percentage: json["percentage"] ?? 0,
      remaining: json["remaining"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "goal": goal,
      "gain": gain,
      "percentage": percentage,
      "remaining": remaining,
    };
  }
}

class TodayMeal {
  final String id;
  final String user;
  final String mealName;
  final num calories;
  final num proteins;
  final num carbs;
  final num fats;
  final DateTime createdAt;
  final DateTime updatedAt;

  TodayMeal({
    required this.id,
    required this.user,
    required this.mealName,
    required this.calories,
    required this.proteins,
    required this.carbs,
    required this.fats,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TodayMeal.fromJson(Map<String, dynamic> json) {
    return TodayMeal(
      id: json["_id"] ?? "",
      user: json["user"] ?? "",
      mealName: json["mealName"] ?? "",
      calories: json["calories"] ?? 0,
      proteins: json["proteins"] ?? 0,
      carbs: json["carbs"] ?? 0,
      fats: json["fats"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? "") ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? "") ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "user": user,
      "mealName": mealName,
      "calories": calories,
      "proteins": proteins,
      "carbs": carbs,
      "fats": fats,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
    };
  }
}
