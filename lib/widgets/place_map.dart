import 'package:eventernote/models/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceMap extends StatelessWidget {
  final Place place;
  final Color color;
  final bool hideWhenNoLatLng;

  const PlaceMap(
    this.place, {
    this.color,
    this.hideWhenNoLatLng = false,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget map = Container();
    if (place.latitude == 0 || place.longitude == 0) {
      if (hideWhenNoLatLng) {
        return map;
      }
      map = Container(
        color: Colors.blue[200],
        alignment: Alignment.center,
        child: Text('緯度経度はございません。', style: TextStyle(color: Colors.white)),
      );
    } else {
      map = GestureDetector(
        onTap: () async => await launch(place.geoUri),
        child: FlutterMap(
          options: MapOptions(
            center: place.latLng,
            zoom: 14,
            interactive: false,
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
            ),
            MarkerLayerOptions(
              markers: [
                Marker(
                  point: place.latLng,
                  builder: (ctx) => Container(
                    child: Icon(
                      Icons.place,
                      color: color ?? Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(height: 100, child: map),
    );
  }
}
