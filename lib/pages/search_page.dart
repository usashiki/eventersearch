import 'package:eventersearch/services/eventernote_service.dart';
import 'package:eventersearch/services/vertical_search_delegate.dart';
import 'package:eventersearch/widgets/actor_carousel_card.dart';
import 'package:eventersearch/widgets/event_carousel_card.dart';
import 'package:eventersearch/widgets/header_tile.dart';
import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _SearchBarButton(),
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
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
          SizedBox(height: 8),
          HeaderTile(
            icon: Icons.info_outline,
            child: Text('このアプリについて'),
            onTap: () => showAboutDialog(
              context: context,
              applicationIcon: Icon(Icons.search, size: 42),
              applicationVersion: '0.0.0',
              children: <Widget>[
                Text('このアプリは株式会社イベンターノート(www.eventernote.com)とは一切関係ありません。'),
              ],
            ),
          ),
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

class _NewActors extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      height: 150.0,
      child: PagewiseListView(
        pageSize: EventernoteService.PAGE_SIZE,
        scrollDirection: Axis.horizontal,
        loadingBuilder: (_) => const _HorizontalLoadingCircle(),
        itemBuilder: (_, actor, i) => ActorCarouselCard(actor),
        pageFuture: (page) => EventernoteService().getNewActors(page),
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
        pageSize: EventernoteService.PAGE_SIZE,
        scrollDirection: Axis.horizontal,
        loadingBuilder: (_) => const _HorizontalLoadingCircle(),
        itemBuilder: (_, actor, i) => ActorCarouselCard(actor, rank: i),
        pageFuture: (page) => EventernoteService().getPopularActors(page),
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
        pageSize: EventernoteService.PAGE_SIZE,
        scrollDirection: Axis.horizontal,
        loadingBuilder: (_) => const _HorizontalLoadingCircle(),
        itemBuilder: (_, event, i) => EventCarouselCard(event),
        pageFuture: (page) =>
            EventernoteService().getEventsForDate(DateTime.now(), page),
      ),
    );
  }
}

class _HorizontalLoadingCircle extends StatelessWidget {
  const _HorizontalLoadingCircle({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: const Align(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
