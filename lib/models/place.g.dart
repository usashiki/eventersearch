// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Place _$PlaceFromJson(Map<String, dynamic> json) {
  return Place(
    id: json['id'] as int,
    name: json['place_name'] as String,
    prefecture: json['prefecture'] as int,
    address: json['address'] as String,
    postalcode: json['postalcode'] as String,
    tel: json['tel'] as String,
    longitude: double.tryParse(json['longitude'] as String),
    latitude: double.tryParse(json['latitude'] as String),
    userId: json['user_id'] as int,
    capacity: json['capacity'] as String,
    webUrl: json['web_url'] as String,
    seatUrl: json['seat_url'] as String,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
    tips: json['tips'] as String,
    editedAt: json['edited_at'] == null
        ? null
        : DateTime.parse(json['edited_at'] as String),
  );
}

Map<String, dynamic> _$PlaceToJson(Place instance) => <String, dynamic>{
      'id': instance.id,
      'place_name': instance.name,
      'prefecture': instance.prefecture,
      'address': instance.address,
      'postalcode': instance.postalcode,
      'tel': instance.tel,
      'longitude': Place._doubleToString(instance.longitude),
      'latitude': Place._doubleToString(instance.latitude),
      'user_id': instance.userId,
      'capacity': instance.capacity,
      'web_url': instance.webUrl,
      'seat_url': instance.seatUrl,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'tips': instance.tips,
      'edited_at': instance.editedAt?.toIso8601String(),
    };
