import 'package:eventersearch/models/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceMap extends StatelessWidget {
  final Place place;

  /// Given a [place], displays a [FlutterMap] centered on the coordinates of
  /// [place] with a pin in the middle which can be tapped to open the the place
  /// in a map app (see [Place.geoUri]).
  ///
  /// If [place]'s coordinates are invalid, instead displays a plain blue
  /// [Container] with an error message.
  const PlaceMap(this.place, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (place.latLng == null) {
      return Container(
        color: Colors.blue[200],
        alignment: Alignment.center,
        child: const Text(
          '緯度経度はございません。',
          style: TextStyle(color: Colors.white),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () => launch(place.geoUri),
        child: FlutterMap(
          options: MapOptions(
            center: place.latLng,
            zoom: 14,
            interactive: false,
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
            ),
            MarkerLayerOptions(
              markers: [
                Marker(
                  point: place.latLng,
                  builder: (ctx) => Icon(
                    Icons.place,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }
}
