class NotificationFilterParams {
  final int page;
  final int limit;

  const NotificationFilterParams({this.page = 1, this.limit = 20});

  Map<String, dynamic> toQueryParams() => {'page': page, 'limit': limit};
}
