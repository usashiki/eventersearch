import 'package:eventersearch/models/actor.dart';
import 'package:eventersearch/models/event.dart';
import 'package:eventersearch/models/place.dart';
import 'package:eventersearch/models/vertical_search_result.dart';
import 'package:eventersearch/services/eventernote_service.dart';
import 'package:eventersearch/widgets/actor_suggestion_tile.dart';
import 'package:eventersearch/widgets/actor_tile.dart';
import 'package:eventersearch/widgets/event_suggestion_tile.dart';
import 'package:eventersearch/widgets/event_tile.dart';
import 'package:eventersearch/widgets/place_suggestion_tile.dart';
import 'package:eventersearch/widgets/place_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';

class VerticalSearchDelegate extends SearchDelegate<VerticalSearchResult> {
  @override
  String get searchFieldLabel => '声優やイベント名を入力';

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Theme.of(context)
        : super.appBarTheme(context);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = '',
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    }
    return SearchResults(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    }
    return FutureBuilder<List<VerticalSearchResult>>(
      future: EventernoteService().getVertical(query),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final results = snapshot.data as List<VerticalSearchResult>;
          if (results != null && results.isNotEmpty) {
            final result = results[0];
            final children = <Widget>[];
            if (result.actors != null) {
              for (final actor in result.actors) {
                children.add(ActorSuggestionTile(actor));
                children.add(const Divider(height: 0.5));
              }
            }
            if (result.events != null) {
              for (final event in result.events) {
                children.add(EventSuggestionTile(event));
                children.add(const Divider(height: 0.5));
              }
            }
            if (result.places != null) {
              for (final place in result.places) {
                children.add(PlaceSuggestionTile(place));
                children.add(const Divider(height: 0.5));
              }
            }
            return ListView(
              children: children,
            );
          }
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class SearchResults extends StatefulWidget {
  final String query;

  const SearchResults(this.query, {Key key}) : super(key: key);

  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(0, 80),
        child: TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).textTheme.headline6.color,
          unselectedLabelColor: Theme.of(context).textTheme.caption.color,
          tabs: [
            FutureBuilder<int>(
              future: EventernoteService().getNumActorsForKeyword(widget.query),
              builder: (_, ss) => Tab(text: '声優/ｱｰﾃｨｽﾄ(${futureInt(ss)})'),
            ),
            FutureBuilder<int>(
              future: EventernoteService().getNumEventsForKeyword(widget.query),
              builder: (_, ss) => Tab(text: 'イベント(${futureInt(ss)})'),
            ),
            FutureBuilder<int>(
              future: EventernoteService().getNumPlacesForKeyword(widget.query),
              builder: (_, ss) => Tab(text: '会場(${futureInt(ss)})'),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ActorResults(widget.query),
          _EventResults(widget.query),
          _PlaceResults(widget.query),
        ],
      ),
    );
  }
}

class _ActorResults extends StatelessWidget {
  final String query;

  const _ActorResults(this.query, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PagewiseListView<Actor>(
      pageSize: EventernoteService.pageSize,
      itemBuilder: (_, actor, i) {
        return Column(children: [ActorTile(actor), const Divider(height: 0.5)]);
      },
      pageFuture: (page) =>
          EventernoteService().getActorsForKeyword(query, page),
    );
  }
}

class _EventResults extends StatelessWidget {
  final String query;

  const _EventResults(this.query, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PagewiseListView<Event>(
      pageSize: EventernoteService.pageSize,
      itemBuilder: (_, event, i) {
        return Column(
          children: [
            EventTile(event, showTime: false),
            const Divider(height: 0.5),
          ],
        );
      },
      pageFuture: (page) =>
          EventernoteService().getEventsForKeyword(query, page),
    );
  }
}

class _PlaceResults extends StatelessWidget {
  final String query;

  const _PlaceResults(this.query, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PagewiseListView<Place>(
      pageSize: EventernoteService.pageSize,
      itemBuilder: (_, place, i) {
        return Column(children: [PlaceTile(place), const Divider(height: 0.5)]);
      },
      pageFuture: (page) =>
          EventernoteService().getPlacesForKeyword(query, page),
    );
  }
}
