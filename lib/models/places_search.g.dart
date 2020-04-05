// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'places_search.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlacesSearch _$PlacesSearchFromJson(Map<String, dynamic> json) {
  return PlacesSearch(
    info: json['info'] == null
        ? null
        : Pagination.fromJson(json['info'] as Map<String, dynamic>),
    results: (json['results'] as List)
        ?.map(
            (e) => e == null ? null : Place.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PlacesSearchToJson(PlacesSearch instance) =>
    <String, dynamic>{
      'info': instance.info?.toJson(),
      'results': instance.results?.map((e) => e?.toJson())?.toList(),
    };
