import 'package:json_annotation/json_annotation.dart';
import 'package:latlong/latlong.dart';

part 'place.g.dart';

@JsonSerializable()
class Place {
  final int id;

  @JsonKey(name: 'place_name')
  final String name;

  final int prefecture; // enum?
  final String address;
  final String postalcode;
  final String tel;

  @JsonKey(fromJson: double.tryParse, toJson: _doubleToString)
  final double longitude;

  @JsonKey(fromJson: double.tryParse, toJson: _doubleToString)
  final double latitude;

  final int userId;
  final String capacity;
  final String webUrl;
  final String seatUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  // final int deleteFlag;
  final String tips;
  final DateTime editedAt;
  // final int hasImage;

  Place({
    this.id,
    this.name,
    this.prefecture,
    this.address,
    this.postalcode,
    this.tel,
    this.longitude,
    this.latitude,
    this.userId,
    this.capacity,
    this.webUrl,
    this.seatUrl,
    this.createdAt,
    this.updatedAt,
    // this.deleteFlag,
    this.tips,
    this.editedAt,
    // this.hasImage,
  });

  static String _doubleToString(double d) => "$d";

  String get eventernoteUrl => "https://www.eventernote.com/places/$id";
  LatLng get latLng {
    if (latitude != null &&
        longitude != null &&
        !latitude.isNaN &&
        !longitude.isNaN &&
        latitude >= -90.0 &&
        latitude <= 90.0 &&
        longitude >= -180.0 &&
        longitude <= 180.0 &&
        latitude != 0.0 &&
        longitude != 0.0) {
      return LatLng(latitude, longitude);
    }
    return null;
  }

  String get prefectureStr => _prefectures[prefecture];
  String get geoUri =>
      "geo:$latitude,$longitude?q=${Uri.encodeQueryComponent(name)}";
  String get telUri => "tel:$tel";

  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);
  Map<String, dynamic> toJson() => _$PlaceToJson(this);
}

const Map<int, String> _prefectures = {
  1: '北海道',
  2: '青森県',
  3: '岩手県',
  4: '宮城県',
  5: '秋田県',
  6: '山形県',
  7: '福島県',
  8: '茨城県',
  9: '栃木県',
  10: '群馬県',
  11: '埼玉県',
  12: '千葉県',
  13: '東京都',
  14: '神奈川県',
  15: '新潟県',
  16: '富山県',
  17: '石川県',
  18: '福井県',
  19: '山梨県',
  20: '長野県',
  21: '岐阜県',
  22: '静岡県',
  23: '愛知県',
  24: '三重県',
  25: '滋賀県',
  26: '京都府',
  27: '大阪府',
  28: '兵庫県',
  29: '奈良県',
  30: '和歌山県',
  31: '鳥取県',
  32: '島根県',
  33: '岡山県',
  34: '広島県',
  35: '山口県',
  36: '徳島県',
  37: '香川県',
  38: '愛媛県',
  39: '高知県',
  40: '福岡県',
  41: '佐賀県',
  42: '長崎県',
  43: '熊本県',
  44: '大分県',
  45: '宮崎県',
  46: '鹿児島県',
  47: '沖縄県',
  90: '海外',
};
