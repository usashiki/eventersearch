import 'dart:async';
import 'dart:convert';

import 'package:eventernote/models/place.dart';
import 'package:eventernote/models/places_search.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class EventernotePlaceService {
  static const PAGE_SIZE = 100;
  static const _baseUrl = 'https://www.eventernote.com/api';
  static const _placesUrl = "$_baseUrl/places/search";
  final _EventernotePlaceCacheManager _cache;

  static EventernotePlaceService _instance;

  factory EventernotePlaceService() {
    if (_instance == null) {
      _instance = new EventernotePlaceService._();
    }
    return _instance;
  }

  EventernotePlaceService._() : _cache = _EventernotePlaceCacheManager();

  int _offset(int page) {
    return page * PAGE_SIZE + 1;
  }

  Future<Map<String, dynamic>> _get(String url) async {
    final file = await _cache.getSingleFile(url);
    return jsonDecode(await file.readAsString());
  }

  Future<int> getNumPlacesForPref(int pref) async {
    final json =
        await _get('$_placesUrl?prefecture=$pref&offset=1&limit=$PAGE_SIZE');
    return PlacesSearch.fromJson(json).info.total;
  }

  Future<List<Place>> getPlacesForPref(int pref, int page) async {
    final json = await _get(
        '$_placesUrl?prefecture=$pref&offset=${_offset(page)}&limit=$PAGE_SIZE');
    return PlacesSearch.fromJson(json).results;
  }
}

class _EventernotePlaceCacheManager extends BaseCacheManager {
  static const key = "eventernotePlaceCache";

  static _EventernotePlaceCacheManager _instance;

  factory _EventernotePlaceCacheManager() {
    if (_instance == null) {
      _instance = new _EventernotePlaceCacheManager._();
    }
    return _instance;
  }

  _EventernotePlaceCacheManager._()
      : super(key,
            maxAgeCacheObject: Duration(days: 30),
            fileFetcher: _customHttpGetter);

  @override
  Future<String> getFilePath() async {
    var directory = await getTemporaryDirectory();
    return p.join(directory.path, key);
  }

  static Future<FileFetcherResponse> _customHttpGetter(String url,
      {Map<String, String> headers}) async {
    print('EventernotePlaceService: fetching $url');
    return HttpFileFetcherResponse(await http.get(url, headers: headers));
  }
}
