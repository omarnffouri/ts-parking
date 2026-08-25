import 'package:equatable/equatable.dart';

class PaginatedResponse<T> extends Equatable {
  final List<T> data;
  final PaginationMeta meta;

  const PaginatedResponse({required this.data, required this.meta});

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PaginatedResponse(
      data: (json['data'] as List? ?? [])
          .map((e) => fromJsonT(e as Map<String, dynamic>))
          .toList(),
      meta: PaginationMeta.fromJson(json['meta'] ?? {}),
    );
  }

  bool get hasMore => meta.hasMore;
  bool get isEmpty => data.isEmpty;
  bool get isNotEmpty => data.isNotEmpty;

  @override
  List<Object?> get props => [data, meta];
}

class PaginationMeta extends Equatable {
  final int total;
  final int page;
  final int limit;
  final int totalPages;
  final bool hasMore;

  const PaginationMeta({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.hasMore,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    final total = (json['total'] as num?)?.toInt() ?? 0;
    final page = (json['page'] as num?)?.toInt() ?? 1;
    final limit = (json['limit'] as num?)?.toInt() ?? 20;
    final totalPages =
        (json['totalPages'] as num?)?.toInt() ??
        (json['total_pages'] as num?)?.toInt() ??
        (limit > 0 ? (total / limit).ceil() : 1);

    return PaginationMeta(
      total: total,
      page: page,
      limit: limit,
      totalPages: totalPages <= 0 ? 1 : totalPages,
      hasMore:
          (json['hasMorePages'] as bool?) ??
          (json['has_more'] as bool?) ??
          false,
    );
  }

  static const empty = PaginationMeta(
    total: 0,
    page: 1,
    limit: 10,
    totalPages: 1,
    hasMore: false,
  );

  @override
  List<Object?> get props => [total, page, limit, totalPages, hasMore];
}
