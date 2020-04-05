import 'package:eventersearch/models/pagination.dart';
import 'package:eventersearch/models/vertical_search_result.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vertical_search.g.dart';

@JsonSerializable()
class VerticalSearch {
  final Pagination info;
  final List<VerticalSearchResult> results;

  VerticalSearch({this.info, this.results});

  factory VerticalSearch.fromJson(Map<String, dynamic> json) =>
      _$VerticalSearchFromJson(json);
  Map<String, dynamic> toJson() => _$VerticalSearchToJson(this);
}
