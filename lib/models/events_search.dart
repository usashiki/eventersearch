import 'package:eventersearch/models/event.dart';
import 'package:eventersearch/models/pagination.dart';
import 'package:json_annotation/json_annotation.dart';

part 'events_search.g.dart';

@JsonSerializable()
class EventsSearch {
  final Pagination info;
  final List<Event> results;

  const EventsSearch({this.info, this.results});

  factory EventsSearch.fromJson(Map<String, dynamic> json) =>
      _$EventsSearchFromJson(json);
  Map<String, dynamic> toJson() => _$EventsSearchToJson(this);
}
