import 'dart:async';
import 'dart:math';

import 'package:eventernote/models/place.dart';
import 'package:eventernote/pages/place_page.dart';
import 'package:eventernote/services/eventernote_place_service.dart';
import 'package:eventernote/widgets/fade_indexed_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:map_controller/map_controller.dart';

class PlaceMapPage extends StatefulWidget with NavigationPage {
  String get title => 'イベント・ライブ会場マップ';
  String get navTitle => '会場マップ';
  IconData get icon => Icons.map;

  @override
  _PlaceMapPageState createState() => _PlaceMapPageState();
}

class _PlaceMapPageState extends State<PlaceMapPage> {
  MapController _mc;
  StatefulMapController _smc;
  StreamSubscription<StatefulMapControllerStateChange> _sub;
  int _pref;
  Map<int, int> _prefCounts;

  @override
  void initState() {
    super.initState();

    _mc = MapController();
    _smc = StatefulMapController(mapController: _mc);
    _smc.onReady.then((_) => print("The map controller is ready"));
    _sub = _smc.changeFeed.listen((change) => setState(() {}));

    _pref = 1;
    _prefCounts = {};
    _getCounts();
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        DropdownButton(
          value: _pref,
          items: [
            for (final p in _prefectures.entries)
              DropdownMenuItem<int>(
                value: p.key,
                child: Text(p.value),
              )
          ],
          onChanged: (newValue) {
            setState(() {
              _pref = newValue;
            });
            _getPlaces();
          },
        ),
        Expanded(
          child: FlutterMap(
            mapController: _mc,
            options: MapOptions(
              center: LatLng(35.693111, 139.749361),
              zoom: 4.7,
              minZoom: 0.0,
              maxZoom: 19.0,
            ),
            layers: [
              TileLayerOptions(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayerOptions(markers: _smc.markers),
              PolylineLayerOptions(polylines: _smc.lines),
              PolygonLayerOptions(polygons: _smc.polygons),
            ],
          ),
        ),
      ],
    );
  }

  void _getCounts() async {
    for (int prefId in _prefectures.keys) {
      _prefCounts[prefId] =
          await EventernotePlaceService().getNumPlacesForPref(prefId);
    }
  }

  void _getPlaces() async {
    // clear existing markers
    _smc.removeMarkers(names: _smc.namedMarkers.keys.toList());

    double minLat = 90, maxLat = -90, minLng = 180, maxLng = -180;
    for (int i = 0; _smc.markers.length < _prefCounts[_pref]; i++) {
      final places = await EventernotePlaceService().getPlacesForPref(_pref, i);
      if (places == null || places.isEmpty) {
        break;
      }
      for (Place p in places) {
        if (p.latLng != null) {
          _smc.addMarker(
            name: p.name,
            marker: Marker(
              width: 80.0,
              height: 80.0,
              point: p.latLng,
              builder: (context) {
                return GestureDetector(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PlacePage(p))),
                  child: Icon(
                    Icons.place,
                    color: Theme.of(context).primaryColor,
                  ),
                );
              },
            ),
          );
          minLat = min(minLat, p.latitude);
          maxLat = max(maxLat, p.latitude);
          minLng = min(minLng, p.longitude);
          maxLng = max(maxLng, p.longitude);
        }
      }
    }
    _mc.fitBounds(LatLngBounds(LatLng(minLat, minLng), LatLng(maxLat, maxLng)));
    _smc.zoomTo(_mc.zoom - 0.1);
  }
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
