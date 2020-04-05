// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'actor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Actor _$ActorFromJson(Map<String, dynamic> json) {
  return Actor(
    id: json['id'] as int,
    name: json['name'] as String,
    kana: json['kana'] as String,
    initial: json['initial'] as String,
    sex: json['sex'] as int,
    keyword: json['keyword'] as String,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
    userId: json['user_id'] as int,
    favoriteCount: json['favorite_count'] as int,
  );
}

Map<String, dynamic> _$ActorToJson(Actor instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'kana': instance.kana,
      'initial': instance.initial,
      'sex': instance.sex,
      'user_id': instance.userId,
      'keyword': instance.keyword,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'favorite_count': instance.favoriteCount,
    };
