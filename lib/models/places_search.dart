import 'package:eventersearch/models/pagination.dart';
import 'package:eventersearch/models/place.dart';
import 'package:json_annotation/json_annotation.dart';

part 'places_search.g.dart';

@JsonSerializable()
class PlacesSearch {
  final Pagination info;
  final List<Place> results;

  PlacesSearch({this.info, this.results});

  factory PlacesSearch.fromJson(Map<String, dynamic> json) =>
      _$PlacesSearchFromJson(json);
  Map<String, dynamic> toJson() => _$PlacesSearchToJson(this);
}
