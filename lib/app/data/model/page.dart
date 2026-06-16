class PageMetaModel {
  final int page;
  final int size;
  final int total;
  final bool hasMore;

  PageMetaModel({
    required this.page,
    required this.size,
    required this.total,
    required this.hasMore,
  });

  factory PageMetaModel.fromJson(Map<String, dynamic> json) {
    return PageMetaModel(
      page: json['page'] is int ? json['page'] as int : int.tryParse('${json['page']}') ?? 0,
      size: json['size'] is int ? json['size'] as int : int.tryParse('${json['size']}') ?? 0,
      total: json['total'] is int ? json['total'] as int : int.tryParse('${json['total']}') ?? 0,
      hasMore: json['has_more'] == true,
    );
  }

  Map<String, dynamic> toJson() => {
    'page': page,
    'size': size,
    'total': total,
    'has_more': hasMore,
  };
}

class PageModel<T> {
  final List<T> items;
  final PageMetaModel meta;

  PageModel({required this.items, required this.meta});

  factory PageModel.fromJson(
      Map<String, dynamic> json,
      T Function(Map<String, dynamic>) fromJsonT,
      ) {
    // meta 유효성 체크
    final metaRaw = json['meta'];
    if (metaRaw == null || metaRaw is! Map<String, dynamic>) {
      throw const FormatException("Invalid payload: 'meta' is missing or not an object");
    }

    // items 유효성 체크
    final rawItems = json['items'];
    final List<T> parsedItems;

    if (rawItems == null) {
      parsedItems = <T>[]; // items가 null → 빈 리스트 처리
    } else if (rawItems is List) {
      parsedItems = rawItems
          .whereType<Map<String, dynamic>>() // Map 타입만 변환
          .map(fromJsonT)
          .toList();
    } else {
      throw const FormatException("Invalid payload: 'items' is not a list");
    }

    return PageModel<T>(
      items: parsedItems,
      meta: PageMetaModel.fromJson(metaRaw),
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) => {
    'items': items.map(toJsonT).toList(),
    'meta': meta.toJson(),
  };
}
