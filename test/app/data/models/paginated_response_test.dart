import 'package:flutter_test/flutter_test.dart';
import 'package:ts_parking/app/data/models/paginated_response.dart';

void main() {
  test('fromJson parses data and meta', () {
    final response = PaginatedResponse<Map<String, dynamic>>.fromJson({
      'data': [
        {'id': 1},
        {'id': 2},
        {'id': 3},
      ],
      'meta': {'total': 10, 'page': 1, 'limit': 3, 'hasMorePages': true},
    }, (json) => json);

    expect(response.data, hasLength(3));
    expect(response.meta.total, 10);
    expect(response.meta.page, 1);
    expect(response.meta.limit, 3);
    expect(response.meta.hasMore, isTrue);
    expect(response.hasMore, isTrue);
    expect(response.isEmpty, isFalse);
  });

  test('fromJson handles snake_case meta keys', () {
    final response = PaginatedResponse<Map<String, dynamic>>.fromJson({
      'data': [],
      'meta': {
        'total': 0,
        'page': 1,
        'limit': 20,
        'total_pages': 1,
        'has_more': false,
      },
    }, (json) => json);

    expect(response.meta.totalPages, 1);
    expect(response.meta.hasMore, isFalse);
    expect(response.isEmpty, isTrue);
  });

  test('fromJson handles null data and meta', () {
    final response = PaginatedResponse<Map<String, dynamic>>.fromJson(
      {},
      (json) => json,
    );

    expect(response.data, isEmpty);
    expect(response.meta.total, 0);
  });
}
