import 'dart:async';
import 'dart:convert';

import 'package:eventernote/models/actor.dart';
import 'package:eventernote/models/actors_search.dart';
import 'package:eventernote/models/event.dart';
import 'package:eventernote/models/events_search.dart';
import 'package:eventernote/models/place.dart';
import 'package:eventernote/models/places_search.dart';
import 'package:eventernote/models/vertical_search.dart';
import 'package:eventernote/models/vertical_search_result.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class EventernoteService {
  static const PAGE_SIZE = 10; // eventernote default
  static const _baseUrl = 'https://www.eventernote.com/api';
  static const _actorsUrl = "$_baseUrl/actors/search";
  static const _eventsUrl = "$_baseUrl/events/search";
  static const _placesUrl = "$_baseUrl/places/search";
  static const _verticalUrl = "$_baseUrl/vertical/search";
  final _EventernoteCacheManager _cache;

  static EventernoteService _instance;

  factory EventernoteService() {
    if (_instance == null) {
      _instance = new EventernoteService._();
    }
    return _instance;
  }

  EventernoteService._() : _cache = _EventernoteCacheManager();

  int _offset(int page) {
    return page * PAGE_SIZE + 1;
  }

  Future<Map<String, dynamic>> _get(String url) async {
    // _cache.emptyCache(); // uncomment to not cache
    final file = await _cache.getSingleFile(url);
    return jsonDecode(await file.readAsString());
  }

  Future<List<Actor>> getPopularActors(int page) async {
    final json = await _get(
        '$_actorsUrl?sort=favorite_count&order=DESC&offset=${_offset(page)}');
    return ActorsSearch.fromJson(json).results;
  }

  Future<List<Actor>> getNewActors(int page) async {
    final json = await _get(
        '$_actorsUrl?sort=created_at&order=DESC&offset=${_offset(page)}');
    return ActorsSearch.fromJson(json).results;
  }

  Future<int> getNumEventsForDate(DateTime date) async {
    final json = await _get(
        '$_eventsUrl?year=${date.year}&month=${date.month}&day=${date.day}&offset=1');
    return EventsSearch.fromJson(json).info.total;
  }

  Future<List<Event>> getEventsForDate(DateTime date, int page) async {
    final json = await _get(
        '$_eventsUrl?year=${date.year}&month=${date.month}&day=${date.day}&offset=${_offset(page)}');
    return EventsSearch.fromJson(json).results;
  }

  Future<int> getNumEventsForActor(int actorId) async {
    final json = await _get('$_eventsUrl?actor_id=$actorId&offset=1');
    return EventsSearch.fromJson(json).info.total;
  }

  Future<List<Event>> getEventsForActor(int actorId, int page) async {
    final json =
        await _get('$_eventsUrl?actor_id=$actorId&offset=${_offset(page)}');
    return EventsSearch.fromJson(json).results;
  }

  Future<List<Event>> getEventsForPlace(int placeId, int page) async {
    final json =
        await _get('$_eventsUrl?place_id=$placeId&offset=${_offset(page)}');
    return EventsSearch.fromJson(json).results;
  }

  Future<List<VerticalSearchResult>> getVertical(String keyword) async {
    final json = await _get('$_verticalUrl?keyword=$keyword');
    return VerticalSearch.fromJson(json).results;
  }
}

class _EventernoteCacheManager extends BaseCacheManager {
  static const key = "eventernoteCache";

  static _EventernoteCacheManager _instance;

  factory _EventernoteCacheManager() {
    if (_instance == null) {
      _instance = new _EventernoteCacheManager._();
    }
    return _instance;
  }

  _EventernoteCacheManager._()
      : super(key,
            maxAgeCacheObject: Duration(days: 1),
            fileFetcher: _customHttpGetter);

  @override
  Future<String> getFilePath() async {
    var directory = await getTemporaryDirectory();
    return p.join(directory.path, key);
  }

  static Future<FileFetcherResponse> _customHttpGetter(String url,
      {Map<String, String> headers}) async {
    print('EventernoteService: fetching $url');
    return HttpFileFetcherResponse(await http.get(url, headers: headers));
  }
}
