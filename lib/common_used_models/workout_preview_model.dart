class WorkoutPreviewModel {
  final String id;
  final String title;
  final String thumbnail;
  final String previewVideo;
  final String skillLevel;
  final num watchTime;

  WorkoutPreviewModel({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.previewVideo,
    required this.skillLevel,
    required this.watchTime,
  });

  factory WorkoutPreviewModel.fromJson(Map<String, dynamic> json) {
    return WorkoutPreviewModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      previewVideo: json['previewVideo'] ?? '',
      skillLevel: json['skillLevel'] ?? '',
      watchTime: json['duration']??0
    );
  }
}