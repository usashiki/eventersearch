import 'package:eventersearch/models/actor.dart';
import 'package:eventersearch/models/event.dart';
import 'package:eventersearch/models/place.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vertical_search_result.g.dart';

@JsonSerializable()
class VerticalSearchResult {
  final List<Event> events;
  final List<Actor> actors;
  final List<Place> places;

  VerticalSearchResult({this.events, this.actors, this.places});

  factory VerticalSearchResult.fromJson(Map<String, dynamic> json) =>
      _$VerticalSearchResultFromJson(json);
  Map<String, dynamic> toJson() => _$VerticalSearchResultToJson(this);
}
