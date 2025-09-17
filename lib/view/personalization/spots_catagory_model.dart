import '../../common_used_models/pagination_model.dart';

class SportsCategoryResponse {
  final String status;
  final int statusCode;
  final String message;
  final CategoryData? data;
  final List<dynamic> errors;

  SportsCategoryResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    this.data,
    required this.errors,
  });

  factory SportsCategoryResponse.fromJson(Map<String, dynamic> json) {
    return SportsCategoryResponse(
      status: json['status'] ?? '',
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null ? CategoryData.fromJson(json['data']) : null,
      errors: json['errors'] ?? [],
    );
  }
}

class CategoryData {
  final String type;
  final CategoryAttributes attributes;

  CategoryData({
    required this.type,
    required this.attributes,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      type: json['type'] ?? '',
      attributes: CategoryAttributes.fromJson(json['attributes']),
    );
  }
}

class CategoryAttributes {
  final List<CategoryItem> category;
  final Pagination pagination;

  CategoryAttributes({
    required this.category,
    required this.pagination,
  });

  factory CategoryAttributes.fromJson(Map<String, dynamic> json) {
    var list = json['category'] as List<dynamic>? ?? [];
    List<CategoryItem> categoryList =
        list.map((e) => CategoryItem.fromJson(e)).toList();

    return CategoryAttributes(
      category: categoryList,
      pagination: Pagination.fromJson(json['pagination']),
    );
  }
}

class CategoryItem {
  final String id;
  final String image;
  final String name;


  CategoryItem({
    required this.id,
    required this.image,
    required this.name,

  });

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    return CategoryItem(
      id: json['_id'] ?? '',
      image: json['image'] ?? '',
      name: json['name'] ?? '',

    );
  }
}

