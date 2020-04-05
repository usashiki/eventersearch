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
import 'package:flutter/widgets.dart' show AsyncSnapshot, debugPrint;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class EventernoteService {
  static const pageSize = 10; // eventernote default
  static const _baseUrl = 'https://www.eventernote.com/api';
  static const _actorsUrl = '$_baseUrl/actors/search';
  static const _eventsUrl = '$_baseUrl/events/search';
  static const _placesUrl = '$_baseUrl/places/search';
  static const _verticalUrl = '$_baseUrl/vertical/search';
  final _EventernoteCacheManager _cache;

  static EventernoteService _instance;

  /// Singleton class for interfacing with the API of
  /// https://www.eventernote.com. All query results are cached for 8 hours.
  factory EventernoteService() => _instance ??= EventernoteService._();

  EventernoteService._() : _cache = _EventernoteCacheManager();

  /// Given a search [keyword], returns [Actor] results, paginated with [page]
  /// and sorted by popularity (favoriteCount descending).
  Future<List<Actor>> getActorsForKeyword(String keyword, int page) async {
    final json = await _get(
        '$_actorsUrl?sort=favorite_count&order=DESC&keyword=$keyword&offset=${_offset(page)}');
    return ActorsSearch.fromJson(json).results;
  }

  /// Given a search [keyword], returns the total number of [Actor] results.
  Future<int> getNumActorsForKeyword(String keyword) async {
    final json = await _get(
        '$_actorsUrl?sort=favorite_count&order=DESC&keyword=$keyword&offset=1');
    return ActorsSearch.fromJson(json).info.total;
  }

  /// Returns the most popular [Actor]s, paginated with [page].
  Future<List<Actor>> getPopularActors(int page) async {
    final json = await _get(
        '$_actorsUrl?sort=favorite_count&order=DESC&offset=${_offset(page)}');
    return ActorsSearch.fromJson(json).results;
  }

  /// Returns the newest [Actor]s, paginated with [page].
  Future<List<Actor>> getNewActors(int page) async {
    final json = await _get(
        '$_actorsUrl?sort=created_at&order=DESC&offset=${_offset(page)}');
    return ActorsSearch.fromJson(json).results;
  }

  /// Given a search [keyword], returns [Event] results, paginated with [page].
  Future<List<Event>> getEventsForKeyword(String keyword, int page) async {
    final json =
        await _get('$_eventsUrl?keyword=$keyword&offset=${_offset(page)}');
    return EventsSearch.fromJson(json).results;
  }

  /// Given a search [keyword], returns the total number of [Event] results.
  Future<int> getNumEventsForKeyword(String keyword) async {
    final json = await _get('$_eventsUrl?keyword=$keyword&offset=1');
    return EventsSearch.fromJson(json).info.total;
  }

  /// Given a [date], returns the total number of [Event]s occurring on [date].
  Future<int> getNumEventsForDate(DateTime date) async {
    final json = await _get(
        '$_eventsUrl?year=${date.year}&month=${date.month}&day=${date.day}&offset=1');
    return EventsSearch.fromJson(json).info.total;
  }

  /// Given a [date], returns the [Event]s occurring on [date], paginated with
  /// [page].
  Future<List<Event>> getEventsForDate(DateTime date, int page) async {
    final json = await _get(
        '$_eventsUrl?year=${date.year}&month=${date.month}&day=${date.day}&offset=${_offset(page)}');
    return EventsSearch.fromJson(json).results;
  }

  /// Given an [actor], returns the total number of [Event]s [actor] has
  /// performed/will perform in.
  Future<int> getNumEventsForActor(Actor actor) async {
    final json = await _get('$_eventsUrl?actor_id=${actor.id}&offset=1');
    return EventsSearch.fromJson(json).info.total;
  }

  /// Given an [actor], returns the [Event]s [actor] has performed/will perform
  /// in, paginated with [page].
  Future<List<Event>> getEventsForActor(Actor actor, int page) async {
    final json =
        await _get('$_eventsUrl?actor_id=${actor.id}&offset=${_offset(page)}');
    return EventsSearch.fromJson(json).results;
  }

  /// Given a list of [actors], returns the [Event]s any non-empty subset of
  /// those [actors] have performed/will perform in, paginated with [page].
  Future<List<Event>> getEventsForActors(List<Actor> actors, int page) async {
    final ids = [for (final a in actors) '${a.id}'].join(',');
    final json =
        await _get('$_eventsUrl?actor_id=$ids&offset=${_offset(page)}');
    return EventsSearch.fromJson(json).results;
  }

  /// Given a [place], returns the [Event]s that have occurred/will occur at
  /// [place] in, paginated with [page].
  Future<List<Event>> getEventsForPlace(Place place, int page) async {
    final json =
        await _get('$_eventsUrl?place_id=${place.id}&offset=${_offset(page)}');
    return EventsSearch.fromJson(json).results;
  }

  /// Given a search [keyword], returns [Place] results, paginated with [page]
  /// and sorted by ISO 3166-2:JP prefecture code ascending (places outside
  /// of Japan are listed last).
  Future<List<Place>> getPlacesForKeyword(String keyword, int page) async {
    final json = await _get(
        '$_placesUrl?sort=prefecture&order=ASC&keyword=$keyword&offset=${_offset(page)}');
    return PlacesSearch.fromJson(json).results;
  }

  /// Given a search [keyword], returns the total number of [Place] results.
  Future<int> getNumPlacesForKeyword(String keyword) async {
    final json = await _get(
        '$_placesUrl?sort=prefecture&order=ASC&keyword=$keyword&offset=1');
    return PlacesSearch.fromJson(json).info.total;
  }

  /// Given a search [keyword], returns a [VerticalSearchResult] result.
  ///
  /// Observations:
  /// - If results are present, there will only be 1 [VerticalSearchResult].
  /// - Each vertical ([Actor], [Event], [Place]) contains up to 5 results.
  /// - [Actor] results are sorted by popularity (favoriteCount descending).
  /// - [Event] results are sorted by date descending.
  /// - [Place] results sorting is unknown.
  Future<List<VerticalSearchResult>> getVertical(String keyword) async {
    final json = await _get('$_verticalUrl?keyword=$keyword');
    return VerticalSearch.fromJson(json).results;
  }

  int _offset(int page) {
    return page * pageSize + 1;
  }

  Future<Map<String, dynamic>> _get(String url) async {
    // _cache.emptyCache(); // uncomment to not cache
    final file = await _cache.getSingleFile(url);
    return jsonDecode(await file.readAsString()) as Map<String, dynamic>;
  }
}

class _EventernoteCacheManager extends BaseCacheManager {
  static const key = 'eventersearchCache';

  static _EventernoteCacheManager _instance;

  factory _EventernoteCacheManager() =>
      _instance ??= _EventernoteCacheManager._();

  _EventernoteCacheManager._()
      : super(key,
            maxAgeCacheObject: const Duration(hours: 8),
            fileFetcher: _customHttpGetter);

  @override
  Future<String> getFilePath() async {
    final directory = await getTemporaryDirectory();
    return p.join(directory.path, key);
  }

  static Future<FileFetcherResponse> _customHttpGetter(String url,
      {Map<String, String> headers}) async {
    debugPrint('EventernoteService: fetching $url');
    return HttpFileFetcherResponse(await http.get(url, headers: headers));
  }
}

/// Given a int [snapshot], returns:
/// - [snapshot] has data: a [String] of the int
/// - [snapshot] has an error: '-'
/// - Else: '?'
///
/// For use with [getNumActorsForKeyword], [getNumEventsForKeyword],
/// [getNumEventsForDate], [getNumEventsForActor], [getNumPlacesForKeyword].
String futureInt(AsyncSnapshot<int> snapshot) {
  if (snapshot.hasData) {
    return '${snapshot.data}';
  } else if (snapshot.hasError) {
    return '-';
  }
  return '?';
}
