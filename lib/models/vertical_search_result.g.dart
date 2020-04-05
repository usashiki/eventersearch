// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'vertical_search_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerticalSearchResult _$VerticalSearchResultFromJson(Map<String, dynamic> json) {
  return VerticalSearchResult(
    events: (json['events'] as List)
        ?.map(
            (e) => e == null ? null : Event.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    actors: (json['actors'] as List)
        ?.map(
            (e) => e == null ? null : Actor.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    places: (json['places'] as List)
        ?.map(
            (e) => e == null ? null : Place.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$VerticalSearchResultToJson(
        VerticalSearchResult instance) =>
    <String, dynamic>{
      'events': instance.events?.map((e) => e?.toJson())?.toList(),
      'actors': instance.actors?.map((e) => e?.toJson())?.toList(),
      'places': instance.places?.map((e) => e?.toJson())?.toList(),
    };
