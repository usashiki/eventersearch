import 'package:community_material_icon/community_material_icon.dart';
import 'package:eventernote/models/vertical_search_result.dart';
import 'package:eventernote/services/eventernote_service.dart';
import 'package:eventernote/widgets/actor_tile.dart';
import 'package:eventernote/widgets/event_tile.dart';
import 'package:eventernote/widgets/place_tile.dart';
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
          List<VerticalSearchResult> results = snapshot.data;
          if (results != null && results.isNotEmpty) {
            VerticalSearchResult result = results[0];
            List<Widget> children = [];
            if (result.actors != null && result.actors.isNotEmpty) {
              children.add(
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('声優/アーティスト'),
                  dense: true,
                ),
              );
              for (final actor in result.actors) {
                children.add(Divider(height: 0.5));
                children.add(ActorTile(actor, expanded: false));
              }
              children.add(Divider(height: 0.5));
            }
            if (result.events != null && result.events.isNotEmpty) {
              children.add(
                ListTile(
                  leading: Icon(CommunityMaterialIcons.microphone_variant),
                  title: Text('イベント'),
                  dense: true,
                ),
              );
              for (final event in result.events) {
                children.add(Divider(height: 0.5));
                children.add(EventTile(event, expanded: false));
              }
              children.add(Divider(height: 0.5));
            }
            if (result.places != null && result.places.isNotEmpty) {
              children.add(
                ListTile(
                  leading: Icon(CommunityMaterialIcons.stadium),
                  title: Text('会場'),
                  dense: true,
                ),
              );
              for (final place in result.places) {
                children.add(Divider(height: 0.5));
                children.add(PlaceTile(place));
              }
            }
            return ListView(children: children);
          }
        }
        return Container(child: Center(child: CircularProgressIndicator()));
      },
    );
  }
}

class SearchResults extends StatefulWidget {
  final String query;

  SearchResults(this.query, {Key key}) : super(key: key);

  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(0, 80),
        child: Container(
          child: TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: '声優/ｱｰﾃｨｽﾄ'),
              Tab(text: 'イベント'),
              Tab(text: '会場'),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ActorResults(widget.query),
          EventResults(widget.query),
          PlaceResults(widget.query),
        ],
      ),
    );
  }
}

class ActorResults extends StatelessWidget {
  final String query;

  ActorResults(this.query, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PagewiseListView(
      pageSize: EventernoteService.PAGE_SIZE,
      itemBuilder: (_, actor, i) {
        return Column(
          children: <Widget>[
            ActorTile(actor),
            Divider(height: 0.5),
          ],
        );
      },
      pageFuture: (page) =>
          EventernoteService().getActorsForKeyword(query, page),
    );
  }
}

class EventResults extends StatelessWidget {
  final String query;

  EventResults(this.query, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PagewiseListView(
      pageSize: EventernoteService.PAGE_SIZE,
      itemBuilder: (_, event, i) {
        return Column(
          children: <Widget>[
            EventTile(event),
            Divider(height: 0.5),
          ],
        );
      },
      pageFuture: (page) =>
          EventernoteService().getEventsForKeyword(query, page),
    );
  }
}

class PlaceResults extends StatelessWidget {
  final String query;

  PlaceResults(this.query, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PagewiseListView(
      pageSize: EventernoteService.PAGE_SIZE,
      itemBuilder: (_, place, i) {
        return Column(
          children: <Widget>[
            PlaceTile(place),
            Divider(height: 0.5),
          ],
        );
      },
      pageFuture: (page) =>
          EventernoteService().getPlacesForKeyword(query, page),
    );
  }
}
