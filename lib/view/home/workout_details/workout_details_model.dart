class WorkoutResponse {
  final String status;
  final int statusCode;
  final String message;
  final WorkoutData data;
  final List<dynamic> errors;

  WorkoutResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.data,
    required this.errors,
  });

  factory WorkoutResponse.fromJson(Map<String, dynamic> json) {
    return WorkoutResponse(
      status: json['status'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: WorkoutData.fromJson(json['data']),
      errors: json['errors'] ?? [],
    );
  }
}

class WorkoutData {
  final String type;
  final Workout attributes;

  WorkoutData({required this.type, required this.attributes});

  factory WorkoutData.fromJson(Map<String, dynamic> json) {
    return WorkoutData(
      type: json['type'],
      attributes: Workout.fromJson(json['attributes']),
    );
  }
}

class Workout {
  final String id;
  final String title;
  final String sports;
  final String description;
  final String thumbnail;
  final num duration;
  final String previewVideo;
  final String userType;
  final String skillLevel;
  final String ageGroup;
  final String goal;
  final List<Chapter> chapters;
  final String createdAt;
  final String updatedAt;
  final int v;

  Workout({
    required this.id,
    required this.title,
    required this.sports,
    required this.description,
    required this.thumbnail,
    required this.duration,
    required this.previewVideo,
    required this.userType,
    required this.skillLevel,
    required this.ageGroup,
    required this.goal,
    required this.chapters,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['_id']??"",
      title: json['title']??"",
      sports: json['sports']??"",
      description: json['description']??"",
      thumbnail: json['thumbnail']??"",
      duration: (json['duration']??0 as num).toDouble(),
      previewVideo: json['previewVideo']??"",
      userType: json['userType']??"",
      skillLevel: json['skillLevel']??"",
      ageGroup: json['ageGroup']??"",
      goal: json['goal']??"",
      chapters: (json['chapters'] as List)
          .map((c) => Chapter.fromJson(c??{}))
          .toList(),
      createdAt: json['createdAt']??"",
      updatedAt: json['updatedAt']??"",
      v: json['__v'],
    );
  }
}

class Chapter {
  final String id;
  final String name;
  final List<Video> videos;

  Chapter({
    required this.id,
    required this.name,
    required this.videos,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['_id']??"",
      name: json['name']??"",
      videos: (json['videos'] as List)
          .map((v) => Video.fromJson(v))
          .toList(),
    );
  }
}

class Video {
  final String id;
  final String title;
  final String thumbnail;
  final String videoUrl;
  final double duration;
  bool watched;

  Video({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.videoUrl,
    required this.duration,
    required this.watched,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['_id']??"",
      title: json['title']??"",
      thumbnail: json['thumbnail']??"",
      videoUrl: json['videoUrl']??"",
      duration: (json['duration']??0 as num).toDouble(),
      watched: json['watched'] ?? false,
    );
  }
}
