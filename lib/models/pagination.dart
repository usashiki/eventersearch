import 'package:json_annotation/json_annotation.dart';

part 'pagination.g.dart';

@JsonSerializable()
class Pagination {
  final int total;
  final int returnCount;
  final int offset;
  final int page;
  final int totalPage;

  const Pagination({
    this.total,
    this.returnCount,
    this.offset,
    this.page,
    this.totalPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) =>
      _$PaginationFromJson(json);
  Map<String, dynamic> toJson() => _$PaginationToJson(this);
}
