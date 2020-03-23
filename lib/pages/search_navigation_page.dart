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
      appBar: SearchBarButton(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: <Widget>[
            SizedBox(height: 8),
            Text('人気声優・アーティストランキング'),
            ActorsRanking(),
            SizedBox(height: 8),
            Text('新着声優・アーティスト'),
            NewActors(),
          ],
        ),
      ),
    );
  }
}

class SearchBarButton extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size(double.infinity, 66);

  @override
  Widget build(BuildContext context) {
    // TODO: use OpenContainer to make transition smoother?
    return Container(
      padding: EdgeInsets.all(8.0).copyWith(bottom: 0.0),
      child: Card(
        elevation: 4,
        child: InkWell(
          onTap: () =>
              showSearch(context: context, delegate: VerticalSearchDelegate()),
          child: Container(
            padding: EdgeInsets.all(12.0),
            child: Row(
              children: <Widget>[
                Icon(Icons.search, color: Colors.grey),
                SizedBox(width: 16),
                // Text('声優やイベント名を入力', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
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
