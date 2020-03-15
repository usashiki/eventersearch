// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pagination _$PaginationFromJson(Map<String, dynamic> json) {
  return Pagination(
    total: json['total'] as int,
    returnCount: json['return_count'] as int,
    offset: json['offset'] as int,
    page: json['page'] as int,
    totalPage: json['total_page'] as int,
  );
}

Map<String, dynamic> _$PaginationToJson(Pagination instance) =>
    <String, dynamic>{
      'total': instance.total,
      'return_count': instance.returnCount,
      'offset': instance.offset,
      'page': instance.page,
      'total_page': instance.totalPage,
    };
