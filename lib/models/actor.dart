import 'package:json_annotation/json_annotation.dart';

part 'actor.g.dart';

@JsonSerializable()
class Actor {
  final int id;
  final String name;
  final String kana;
  final String initial;
  final int sex; // enum: 1 = 女性, 2 = 男性, 3 = 混合
  final int userId;
  final String keyword;
  final DateTime createdAt;
  final DateTime updatedAt;
  // final int deleteFlag;
  final int favoriteCount;
  // final String image;
  // final DateTime editedAt;
  // final int hasImage;

  Actor({
    this.id,
    this.name,
    this.kana,
    this.initial,
    this.sex,
    this.keyword,
    this.createdAt,
    this.updatedAt,
    this.userId,
    // this.deleteFlag,
    this.favoriteCount,
    // this.image,
    // this.editedAt,
    // this.hasImage,
  });

  String get eventernoteUrl => "https://www.eventernote.com/actors/$id";
  String get wikiUrl => "https://ja.wikipedia.org/wiki/$name";

  factory Actor.fromJson(Map<String, dynamic> json) => _$ActorFromJson(json);
  Map<String, dynamic> toJson() => _$ActorToJson(this);
}
