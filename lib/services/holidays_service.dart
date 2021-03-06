import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class HolidaysService {
  static const _baseUrl = 'https://holidays-jp.github.io/api/v1';
  final Map<DateTime, List<String>> _holidays;
  final _HolidaysCacheManager _cache;

  static HolidaysService _instance;

  /// Singleton class for checking whether given dates are (Japanese) holidays.
  /// Holidays are stored in [HolidaysService] by year as needed.
  ///
  /// Data is from https://holidays-jp.github.io (API documentation) /
  /// https://github.com/holidays-jp/api (GitHub repo), with query results
  /// cached for 30 days.
  factory HolidaysService() => _instance ??= HolidaysService._();

  HolidaysService._()
      : _holidays = {},
        _cache = _HolidaysCacheManager();

  /// List all stored holidays. Note that holidays are loaded into
  /// HolidaysService from the API/cache as needed, so not all previously
  /// queried/cached holidays may be returned on app reset.
  Map<DateTime, List> get all => _holidays;

  /// Given a [date], checks whether [date] is a Japanese holiday.
  bool isHoliday(DateTime date) {
    // jan 1 is always 元日
    if (_holidays[DateTime.utc(date.year, 1, 1)] == null) {
      _update(date.year);
    }
    return _holidays[DateTime.utc(date.year, date.month, date.day)] != null;
  }

  void _update(int year) async {
    final file = await _cache.getSingleFile('$_baseUrl/$year/date.json');
    Map<String, dynamic> json;
    if (file != null) {
      json = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    } else {
      debugPrint('failed to find holidays for year $year');
      json = <String, dynamic>{
        DateTime.utc(year, 1, 1).toIso8601String(): '元日',
      };
    }
    for (final mapEntry in json.entries) {
      _holidays[DateTime.parse('${mapEntry.key}T00Z')] = [
        mapEntry.value.toString()
      ];
    }
  }
}

class _HolidaysCacheManager extends BaseCacheManager {
  static const key = 'holidaysCache';

  static _HolidaysCacheManager _instance;

  factory _HolidaysCacheManager() => _instance ??= _HolidaysCacheManager._();

  _HolidaysCacheManager._()
      : super(key,
            maxAgeCacheObject: const Duration(days: 30),
            fileFetcher: _customHttpGetter);

  @override
  Future<String> getFilePath() async {
    final directory = await getTemporaryDirectory();
    return p.join(directory.path, key);
  }

  static Future<FileFetcherResponse> _customHttpGetter(String url,
      {Map<String, String> headers}) async {
    debugPrint('HolidaysService: fetching $url');
    return HttpFileFetcherResponse(await http.get(url, headers: headers));
  }
}
