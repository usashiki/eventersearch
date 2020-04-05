import 'package:eventersearch/models/actor.dart';
import 'package:eventersearch/models/event.dart';
import 'package:flutter/material.dart';

class FavoritesState extends ChangeNotifier {
  final Set<Actor> _favoriteActors;
  final Set<Event> _favoriteEvents;

  static FavoritesState _instance;

  /// Singleton class for storing the user's favorite [Actor]s and [Event]s.
  /// As a [ChangeNotifier], changes to favorites can be subscribed to to create
  /// updating UI elements.
  ///
  /// Note that these favorites are NOT persisted to disk in any form, so they
  /// are not persisted on app close.
  factory FavoritesState() => _instance ??= FavoritesState._();

  FavoritesState._()
      : _favoriteActors = {},
        _favoriteEvents = {};

  /// Given an [actor], stores that [actor] as a favorite and notifies
  /// listeners.
  void addActor(Actor actor) {
    _favoriteActors.add(actor);
    notifyListeners();
  }

  /// Given an [actor], removes that [actor] from favorite actors if present and
  /// notifies listeners.
  void removeActor(Actor actor) {
    _favoriteActors.remove(actor);
    notifyListeners();
  }

  /// Given an [actor], checks whether that [actor] is a favorite actor.
  bool containsActor(Actor actor) => _favoriteActors.contains(actor);

  /// Returns the list of favorite [Actor]s.
  List<Actor> get favoriteActors => _favoriteActors.toList();

  /// Given an [event], stores that [event] as a favorite and notifies
  /// listeners.
  void addEvent(Event event) {
    _favoriteEvents.add(event);
    notifyListeners();
  }

  /// Given an [event], removes that [event] from favorite events if present and
  /// notifies listeners.
  void removeEvent(Event event) {
    _favoriteEvents.remove(event);
    notifyListeners();
  }

  /// Given an [event], checks whether that [event] is a favorite event.
  bool containsEvent(Event event) => _favoriteEvents.contains(event);

  /// Returns the list of favorite [Event]s.
  List<Event> get favoriteEvents => _favoriteEvents.toList();
}
