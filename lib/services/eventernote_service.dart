import 'dart:async';
import 'dart:convert';

import 'package:eventersearch/models/actor.dart';
import 'package:eventersearch/models/actors_search.dart';
import 'package:eventersearch/models/event.dart';
import 'package:eventersearch/models/events_search.dart';
import 'package:eventersearch/models/place.dart';
import 'package:eventersearch/models/places_search.dart';
import 'package:eventersearch/models/vertical_search.dart';
import 'package:eventersearch/models/vertical_search_result.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class EventernoteService {
  static const PAGE_SIZE = 10; // eventernote default
  static const _baseUrl = 'https://www.eventernote.com/api';
  static const _actorsUrl = '$_baseUrl/actors/search';
  static const _eventsUrl = '$_baseUrl/events/search';
  static const _placesUrl = '$_baseUrl/places/search';
  static const _verticalUrl = '$_baseUrl/vertical/search';
  final _EventernoteCacheManager _cache;

  static EventernoteService _instance;

  factory EventernoteService() {
    _instance ??= EventernoteService._();
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

  Future<List<Actor>> getActorsForKeyword(String keyword, int page) async {
    final json = await _get(
        '$_actorsUrl?sort=favorite_count&order=DESC&keyword=$keyword&offset=${_offset(page)}');
    return ActorsSearch.fromJson(json).results;
  }

  Future<int> getNumActorsForKeyword(String keyword) async {
    final json = await _get(
        '$_actorsUrl?sort=favorite_count&order=DESC&keyword=$keyword&offset=1');
    return ActorsSearch.fromJson(json).info.total;
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

  Future<List<Event>> getEventsForKeyword(String keyword, int page) async {
    final json =
        await _get('$_eventsUrl?keyword=$keyword&offset=${_offset(page)}');
    return EventsSearch.fromJson(json).results;
  }

  Future<int> getNumEventsForKeyword(String keyword) async {
    final json = await _get('$_eventsUrl?keyword=$keyword&offset=1');
    return EventsSearch.fromJson(json).info.total;
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

  Future<int> getNumEventsForActor(Actor actor) async {
    final json = await _get('$_eventsUrl?actor_id=${actor.id}&offset=1');
    return EventsSearch.fromJson(json).info.total;
  }

  Future<List<Event>> getEventsForActor(Actor actor, int page) async {
    final json =
        await _get('$_eventsUrl?actor_id=${actor.id}&offset=${_offset(page)}');
    return EventsSearch.fromJson(json).results;
  }

  Future<List<Event>> getEventsForActors(List<Actor> actors, int page) async {
    final ids = [for (final a in actors) '${a.id}'].join(',');
    final json =
        await _get('$_eventsUrl?actor_id=$ids&offset=${_offset(page)}');
    return EventsSearch.fromJson(json).results;
  }

  Future<List<Event>> getEventsForPlace(Place place, int page) async {
    final json =
        await _get('$_eventsUrl?place_id=${place.id}&offset=${_offset(page)}');
    return EventsSearch.fromJson(json).results;
  }

  Future<List<Place>> getPlacesForKeyword(String keyword, int page) async {
    final json =
        await _get('$_placesUrl?keyword=$keyword&offset=${_offset(page)}');
    return PlacesSearch.fromJson(json).results;
  }

  Future<int> getNumPlacesForKeyword(String keyword) async {
    final json = await _get('$_placesUrl?keyword=$keyword&offset=1');
    return PlacesSearch.fromJson(json).info.total;
  }

  Future<List<VerticalSearchResult>> getVertical(String keyword) async {
    final json = await _get('$_verticalUrl?keyword=$keyword');
    return VerticalSearch.fromJson(json).results;
  }
}

class _EventernoteCacheManager extends BaseCacheManager {
  static const key = 'eventersearchCache';

  static _EventernoteCacheManager _instance;

  factory _EventernoteCacheManager() {
    _instance ??= _EventernoteCacheManager._();
    return _instance;
  }

  _EventernoteCacheManager._()
      : super(key,
            maxAgeCacheObject: Duration(hours: 8),
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
