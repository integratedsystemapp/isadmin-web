class AlertHistoryResponseModel {
  final int id;
  final String level;
  final String message;
  final String createdAt;

  AlertHistoryResponseModel({
    required this.id,
    required this.level,
    required this.message,
    required this.createdAt,
  });

  factory AlertHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    return AlertHistoryResponseModel(
      id: json['id'],
      level: json['level'],
      message: json['message'],
      createdAt: json['created_at'],
    );
  }
}

class PageMeta {
  final int page;
  final int size;
  final int total;
  final bool hasMore;

  PageMeta({
    required this.page,
    required this.size,
    required this.total,
    required this.hasMore,
  });

  factory PageMeta.fromJson(Map<String, dynamic> json) {
    return PageMeta(
      page: json['page'],
      size: json['size'],
      total: json['total'],
      hasMore: json['has_more'],
    );
  }
}

class Page<T> {
  final List<T> items;
  final PageMeta meta;

  Page({required this.items, required this.meta});

  factory Page.fromJson(
      Map<String, dynamic> json,
      T Function(Map<String, dynamic>) fromJsonT,
      ) {
    var itemsJson = json['items'] as List;
    return Page<T>(
      items: itemsJson.map((e) => fromJsonT(e)).toList(),
      meta: PageMeta.fromJson(json['meta']),
    );
  }
}
