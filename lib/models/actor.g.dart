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
    favoriteCount: json['favorite_count'] as int,
  );
}

Map<String, dynamic> _$ActorToJson(Actor instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'kana': instance.kana,
      'favorite_count': instance.favoriteCount,
    };
