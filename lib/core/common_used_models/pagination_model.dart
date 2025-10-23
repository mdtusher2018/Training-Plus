
class Pagination {
  final int totalResults;
  final int totalPages;
  final int currentPage;
  final int limit;

  Pagination({
    required this.totalResults,
    required this.totalPages,
    required this.currentPage,
    required this.limit,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      totalResults: json["totalResults"] ?? 0,
      totalPages: json["totalPages"] ?? 0,
      currentPage: json["currentPage"] ?? 0,
      limit: json["limit"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "totalResults": totalResults,
      "totalPages": totalPages,
      "currentPage": currentPage,
      "limit": limit,
    };
  }
}