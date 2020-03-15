// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    id: json['id'] as int,
    screenName: json['screen_name'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    profileImageUrl: json['profile_image_url'] as String,
    coverImageUrl: json['cover_image_url'] as String,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
    deleteFlag: json['delete_flag'] as int,
    followingCount: json['following_count'] as int,
    followerCount: json['follower_count'] as int,
    noteCount: json['note_count'] as int,
    twitterScreenName: json['twitter_screen_name'] as String,
    officialFlag: json['official_flag'] as int,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'screen_name': instance.screenName,
      'name': instance.name,
      'description': instance.description,
      'profile_image_url': instance.profileImageUrl,
      'cover_image_url': instance.coverImageUrl,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'delete_flag': instance.deleteFlag,
      'following_count': instance.followingCount,
      'follower_count': instance.followerCount,
      'note_count': instance.noteCount,
      'twitter_screen_name': instance.twitterScreenName,
      'official_flag': instance.officialFlag,
    };
