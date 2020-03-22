import 'package:eventernote/services/eventernote_service.dart';
import 'package:eventernote/services/vertical_search_delegate.dart';
import 'package:eventernote/widgets/actor_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';

class SearchNavigationPage extends StatefulWidget {
  @override
  _SearchNavigationPageState createState() => _SearchNavigationPageState();
}

class _SearchNavigationPageState extends State<SearchNavigationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('検索'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            tooltip: '検索',
            onPressed: () => showSearch(
              context: context,
              delegate: VerticalSearchDelegate(),
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 8),
          Text('人気声優・アーティストランキング'),
          ActorsRanking(),
          SizedBox(height: 8),
          Text('新着声優・アーティスト'),
          NewActors(),
        ],
      ),
    );
  }
}

class ActorsRanking extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: PagewiseListView(
        pageSize: EventernoteService.PAGE_SIZE,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, actor, i) {
          return ActorCard(actor);
        },
        pageFuture: (page) => EventernoteService().getPopularActors(page),
      ),
    );
  }
}

class NewActors extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: PagewiseListView(
        pageSize: EventernoteService.PAGE_SIZE,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, actor, i) {
          return ActorCard(actor);
        },
        pageFuture: (page) => EventernoteService().getNewActors(page),
      ),
    );
  }
}
