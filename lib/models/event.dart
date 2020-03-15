import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:eventernote/models/actor.dart';
import 'package:eventernote/models/place.dart';
import 'package:eventernote/models/user.dart';

part 'event.g.dart';

@JsonSerializable()
class Event {
  final int id;
  @JsonKey(name: 'event_name')
  final String name;

  @JsonKey(name: 'event_date', fromJson: _stringToDate, toJson: _dateToString)
  final DateTime date;

  final int userId;
  final String actorId; // comma-sep list of ids
  final int placeId;
  final String link;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  // final int deleteFlag;
  final int draftFlag;
  final int noteCount;
  final String hashtag;
  final String startTime; // DateTime?
  final String endTime; // DateTime?
  final String openTime; // DateTime?
  // final String reserveTime;
  final DateTime editedAt;

  @JsonKey(fromJson: _intToBool, toJson: _boolToInt)
  final bool hasImage;

  // final int aniutaFlag;
  // final String anisodonHashtag;
  final String url;
  final String imageUrl;
  final String thumbUrl;
  final List<Actor> actors;
  final Place place;
  final User user;

  Event({
    this.id,
    this.name,
    this.date,
    this.userId,
    this.actorId,
    this.placeId,
    this.link,
    this.description,
    this.createdAt,
    this.updatedAt,
    // this.deleteFlag,
    this.draftFlag,
    this.noteCount,
    this.hashtag,
    this.startTime,
    this.endTime,
    this.openTime,
    // this.reserveTime,
    this.editedAt,
    this.hasImage,
    // this.aniutaFlag,
    // this.anisodonHashtag,
    this.url,
    this.imageUrl,
    this.thumbUrl,
    this.actors,
    this.place,
    this.user,
  });

  static DateTime _stringToDate(String s) =>
      DateTime.parse(s); // TODO: timezone?
  static String _dateToString(DateTime d) => DateFormat('yyyy-MM-dd').format(d);

  static bool _intToBool(int i) => i == 1;
  static int _boolToInt(bool b) => b ? 1 : 0;

  String get timesString =>
      "開場 ${openTime ?? '-'} 開演 ${startTime ?? '-'} 終演 ${endTime ?? '-'}";
  String get eventernoteUrl => "https://www.eventernote.com/events/$id";
  List<String> get links => link?.split(RegExp(r"(\r)?\n"));
  String get hashtagUrl => "https://www.twitter.com/search/?q=%23$hashtag";

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
  Map<String, dynamic> toJson() => _$EventToJson(this);
}
