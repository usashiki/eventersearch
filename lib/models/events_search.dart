import 'package:eventernote/models/event.dart';
import 'package:eventernote/models/pagination.dart';
import 'package:json_annotation/json_annotation.dart';

part 'events_search.g.dart';

@JsonSerializable()
class EventsSearch {
  final Pagination info;
  final List<Event> results;

  EventsSearch({this.info, this.results});

  factory EventsSearch.fromJson(Map<String, dynamic> json) =>
      _$EventsSearchFromJson(json);
  Map<String, dynamic> toJson() => _$EventsSearchToJson(this);
}
