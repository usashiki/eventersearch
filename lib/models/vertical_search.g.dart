// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vertical_search.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerticalSearch _$VerticalSearchFromJson(Map<String, dynamic> json) {
  return VerticalSearch(
    info: json['info'] == null
        ? null
        : Pagination.fromJson(json['info'] as Map<String, dynamic>),
    results: (json['results'] as List)
        ?.map((e) => e == null
            ? null
            : VerticalSearchResult.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$VerticalSearchToJson(VerticalSearch instance) =>
    <String, dynamic>{
      'info': instance.info?.toJson(),
      'results': instance.results?.map((e) => e?.toJson())?.toList(),
    };
