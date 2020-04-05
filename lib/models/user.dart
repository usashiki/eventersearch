import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String screenName;
  final String name;
  final String description;
  final String profileImageUrl;
  final String coverImageUrl;
  // final DateTime createdAt;
  // final DateTime updatedAt;
  // final int deleteFlag;
  final int followingCount;
  final int followerCount;
  final int noteCount;
  // final String iosPushDeviceToken;
  // final int pushFlagFollow;
  // final int pushFlagEventAdd;
  final String twitterScreenName;
  final int officialFlag;

  const User({
    this.id,
    this.screenName,
    this.name,
    this.description,
    this.profileImageUrl,
    this.coverImageUrl,
    // this.createdAt,
    // this.updatedAt,
    // this.deleteFlag,
    this.followingCount,
    this.followerCount,
    this.noteCount,
    // this.iosPushDeviceToken,
    // this.pushFlagFollow,
    // this.pushFlagEventAdd,
    this.twitterScreenName,
    this.officialFlag,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
