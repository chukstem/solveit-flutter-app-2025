class GetFilteredPostsQuery {
  final int page;
  final int perPage;
  final int time;

  GetFilteredPostsQuery(
      {required this.page, required this.perPage, required this.time});

  Map<String, String> toQueryParams() {
    return {
      "page": page.toString(),
      "perPage": perPage.toString(),
      "time": time.toString(),
    };
  }

  String toQueryString() {
    return "?time=$time&page=$page&perPage=$perPage";
  }
}
