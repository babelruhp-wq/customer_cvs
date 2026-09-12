class PagedResult<T> {
  final List<T> items;

  final int page;
  final int pageSize;

  final int totalCount;
  final int totalPages;

  const PagedResult({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
  });
}