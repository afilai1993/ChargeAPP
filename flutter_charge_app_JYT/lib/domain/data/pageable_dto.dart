class PageableDTO<T> {
  final int total;
  final List<T> data;

  PageableDTO(this.total, this.data);

  factory PageableDTO.fromJson(Map<String, dynamic> json,
      T Function(Map<String, dynamic> item) mapper) =>
      PageableDTO(json["total"],
          (json["data"] as List<dynamic>).cast<Map<String, dynamic>>().map(mapper).toList());


  void a() {
    [].cast<Map<String, dynamic>>();
  }
}
