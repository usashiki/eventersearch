import 'package:eventersearch/models/actor.dart';
import 'package:eventersearch/models/event.dart';
import 'package:flutter/material.dart';

class FavoritesState extends ChangeNotifier {
  final Set<Actor> _favoriteActors;
  final Set<Event> _favoriteEvents;

  static FavoritesState _instance;

  factory FavoritesState() => _instance ??= FavoritesState._();

  FavoritesState._()
      : _favoriteActors = {},
        _favoriteEvents = {};

  void addActor(Actor actor) {
    _favoriteActors.add(actor);
    notifyListeners();
  }

  void removeActor(Actor actor) {
    _favoriteActors.remove(actor);
    notifyListeners();
  }

  bool containsActor(Actor actor) => _favoriteActors.contains(actor);
  List<Actor> get favoriteActors => _favoriteActors.toList();

  void addEvent(Event event) {
    _favoriteEvents.add(event);
    notifyListeners();
  }

  void removeEvent(Event event) {
    _favoriteEvents.remove(event);
    notifyListeners();
  }

  bool containsEvent(Event event) => _favoriteEvents.contains(event);
  List<Event> get favoriteEvents => _favoriteEvents.toList();
}
