import 'dart:async';
import 'dart:convert';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class HolidaysService {
  static const _baseUrl = 'https://holidays-jp.github.io/api/v1';
  final Map<DateTime, List> _holidays;
  final _HolidaysCacheManager _cache;

  static HolidaysService _instance;

  factory HolidaysService() {
    if (_instance == null) {
      _instance = new HolidaysService._();
    }
    return _instance;
  }

  HolidaysService._()
      : _holidays = {},
        _cache = _HolidaysCacheManager();

  get all => _holidays;

  bool isHoliday(DateTime date) {
    // jan 1 is always 元日
    if (_holidays[DateTime(date.year, 1, 1)] == null) {
      _update(date.year);
    }
    return _holidays[date] != null;
  }

  void _update(int year) async {
    final file = await _cache.getSingleFile('$_baseUrl/$year/date.json');
    if (file != null) {
      Map<String, dynamic> json = jsonDecode(await file.readAsString());
      for (var mapEntry in json.entries) {
        _holidays[DateTime.parse(mapEntry.key)] = [mapEntry.value.toString()];
      }
    }
  }
}

class _HolidaysCacheManager extends BaseCacheManager {
  static const key = "holidaysCache";

  static _HolidaysCacheManager _instance;

  factory _HolidaysCacheManager() {
    if (_instance == null) {
      _instance = new _HolidaysCacheManager._();
    }
    return _instance;
  }

  _HolidaysCacheManager._()
      : super(key,
            maxAgeCacheObject: Duration(days: 365),
            fileFetcher: _customHttpGetter);

  @override
  Future<String> getFilePath() async {
    var directory = await getTemporaryDirectory();
    return p.join(directory.path, key);
  }

  static Future<FileFetcherResponse> _customHttpGetter(String url,
      {Map<String, String> headers}) async {
    print('HolidaysService: fetching $url');
    return HttpFileFetcherResponse(await http.get(url, headers: headers));
  }
}
