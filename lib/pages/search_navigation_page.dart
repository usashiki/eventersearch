import 'package:eventernote/services/eventernote_service.dart';
import 'package:eventernote/services/vertical_search_delegate.dart';
import 'package:eventernote/widgets/actor_carousel_card.dart';
import 'package:eventernote/widgets/event_carousel_card.dart';
import 'package:eventernote/widgets/header_tile.dart';
import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';

class SearchNavigationPage extends StatefulWidget {
  @override
  _SearchNavigationPageState createState() => _SearchNavigationPageState();
}

class _SearchNavigationPageState extends State<SearchNavigationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _SearchBarButton(),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          HeaderTile(
            icon: Icons.fiber_new,
            child: Text('新着声優・アーティスト'),
          ),
          _NewActors(),
          // HeaderTile(
          //   icon: Icons.new_releases,
          //   child: Text('注目の声優・アーティスト'),
          // ),
          HeaderTile(
            icon: Mdi.signal,
            child: Text('人気声優・アーティストランキング'),
          ),
          _ActorsRanking(),
          // HeaderTile(
          //   icon: Icons.fiber_new,
          //   child: Text('新着イベント'),
          // ),
          // HeaderTile(
          //   icon: Icons.new_releases,
          //   child: Text('注目のイベント'),
          // ),
          HeaderTile(
            icon: Mdi.calendarOutline,
            child: Text('今日のイベント'),
          ),
          _TodaysEvents(),
        ],
      ),
    );
  }
}

class _SearchBarButton extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size(double.infinity, 66);

  @override
  Widget build(BuildContext context) {
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
                Text('声優やイベント名を入力', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActorsRanking extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      height: 150.0,
      child: PagewiseListView(
        physics: const BouncingScrollPhysics(),
        pageSize: EventernoteService.PAGE_SIZE,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, actor, i) => ActorCarouselCard(actor, rank: i),
        pageFuture: (page) => EventernoteService().getPopularActors(page),
      ),
    );
  }
}

class _NewActors extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      height: 150.0,
      child: PagewiseListView(
        physics: const BouncingScrollPhysics(),
        pageSize: EventernoteService.PAGE_SIZE,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, actor, i) => ActorCarouselCard(actor),
        pageFuture: (page) => EventernoteService().getNewActors(page),
      ),
    );
  }
}

class _TodaysEvents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      height: 180.0,
      child: PagewiseListView(
        physics: const BouncingScrollPhysics(),
        pageSize: EventernoteService.PAGE_SIZE,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, event, i) => EventCarouselCard(event),
        pageFuture: (page) =>
            EventernoteService().getEventsForDate(DateTime.now(), page),
      ),
    );
  }
}
