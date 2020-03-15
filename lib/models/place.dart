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

  String get geoUri =>
      "geo:$latitude,$longitude?q=${Uri.encodeQueryComponent(name)}";
  String get telUri => "tel:$tel";

  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);
  Map<String, dynamic> toJson() => _$PlaceToJson(this);
}
