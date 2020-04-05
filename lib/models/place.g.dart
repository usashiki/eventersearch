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
    capacity: json['capacity'] as String,
    webUrl: json['web_url'] as String,
    seatUrl: json['seat_url'] as String,
    tips: json['tips'] as String,
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
      'capacity': instance.capacity,
      'web_url': instance.webUrl,
      'seat_url': instance.seatUrl,
      'tips': instance.tips,
    };
