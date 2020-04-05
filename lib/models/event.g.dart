// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) {
  return Event(
    id: json['id'] as int,
    name: json['event_name'] as String,
    date: Event._stringToDate(json['event_date'] as String),
    link: json['link'] as String,
    description: json['description'] as String,
    noteCount: json['note_count'] as int,
    hashtag: json['hashtag'] as String,
    startTime: json['start_time'] as String,
    endTime: json['end_time'] as String,
    openTime: json['open_time'] as String,
    hasImage: Event._intToBool(json['has_image'] as int),
    url: json['url'] as String,
    imageUrl: json['image_url'] as String,
    thumbUrl: json['thumb_url'] as String,
    actors: (json['actors'] as List)
        ?.map(
            (e) => e == null ? null : Actor.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    place: json['place'] == null
        ? null
        : Place.fromJson(json['place'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'id': instance.id,
      'event_name': instance.name,
      'event_date': Event._dateToString(instance.date),
      'link': instance.link,
      'description': instance.description,
      'note_count': instance.noteCount,
      'hashtag': instance.hashtag,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'open_time': instance.openTime,
      'has_image': Event._boolToInt(instance.hasImage),
      'url': instance.url,
      'image_url': instance.imageUrl,
      'thumb_url': instance.thumbUrl,
      'actors': instance.actors?.map((e) => e?.toJson())?.toList(),
      'place': instance.place?.toJson(),
    };
