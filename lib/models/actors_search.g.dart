// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'actors_search.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActorsSearch _$ActorsSearchFromJson(Map<String, dynamic> json) {
  return ActorsSearch(
    info: json['info'] == null
        ? null
        : Pagination.fromJson(json['info'] as Map<String, dynamic>),
    results: (json['results'] as List)
        ?.map(
            (e) => e == null ? null : Actor.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ActorsSearchToJson(ActorsSearch instance) =>
    <String, dynamic>{
      'info': instance.info?.toJson(),
      'results': instance.results?.map((e) => e?.toJson())?.toList(),
    };
