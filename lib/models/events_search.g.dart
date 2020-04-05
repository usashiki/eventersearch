// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'events_search.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventsSearch _$EventsSearchFromJson(Map<String, dynamic> json) {
  return EventsSearch(
    info: json['info'] == null
        ? null
        : Pagination.fromJson(json['info'] as Map<String, dynamic>),
    results: (json['results'] as List)
        ?.map(
            (e) => e == null ? null : Event.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$EventsSearchToJson(EventsSearch instance) =>
    <String, dynamic>{
      'info': instance.info?.toJson(),
      'results': instance.results?.map((e) => e?.toJson())?.toList(),
    };
