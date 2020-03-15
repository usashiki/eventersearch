import 'package:eventernote/models/actor.dart';
import 'package:eventernote/models/pagination.dart';
import 'package:json_annotation/json_annotation.dart';

part 'actors_search.g.dart';

@JsonSerializable()
class ActorsSearch {
  final Pagination info;
  final List<Actor> results;

  ActorsSearch({this.info, this.results});

  factory ActorsSearch.fromJson(Map<String, dynamic> json) =>
      _$ActorsSearchFromJson(json);
  Map<String, dynamic> toJson() => _$ActorsSearchToJson(this);
}
