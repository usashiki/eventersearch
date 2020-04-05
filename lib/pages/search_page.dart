import 'package:eventersearch/models/actor.dart';
import 'package:eventersearch/models/event.dart';
import 'package:eventersearch/services/eventernote_service.dart';
import 'package:eventersearch/services/vertical_search_delegate.dart';
import 'package:eventersearch/widgets/actor_carousel_card.dart';
import 'package:eventersearch/widgets/event_carousel_card.dart';
import 'package:eventersearch/widgets/header_tile.dart';
import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';

class SearchPage extends StatefulWidget {
  /// A search/explore page with a search bar at the top and carousels for newly
  /// added [Actor]s, popular [Actor]s, and today's [Event]s.
  const SearchPage({Key key}) : super(key: key);

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
            child: const Text('新着声優・アーティスト'),
          ),
          _NewActors(),
          // HeaderTile(
          //   icon: Icons.new_releases,
          //   child: Text('注目の声優・アーティスト'),
          // ),
          HeaderTile(
            icon: Mdi.signal,
            child: const Text('人気声優・アーティストランキング'),
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
            child: const Text('今日のイベント'),
          ),
          _TodaysEvents(),
          const SizedBox(height: 8),
          HeaderTile(
            icon: Icons.info_outline,
            onTap: () => showAboutDialog(
              context: context,
              applicationIcon: Icon(Icons.search, size: 42),
              applicationVersion: '0.0.0',
              children: <Widget>[
                const Text(
                    'このアプリは株式会社イベンターノート(www.eventernote.com)とは一切関係ありません。'),
              ],
            ),
            child: const Text('このアプリについて'),
          ),
        ],
      ),
    );
  }
}

class _SearchBarButton extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size(double.infinity, 66);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0).copyWith(bottom: 0.0),
      child: Card(
        elevation: 4,
        child: InkWell(
          onTap: () =>
              showSearch(context: context, delegate: VerticalSearchDelegate()),
          child: Container(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: <Widget>[
                Icon(Icons.search, color: Colors.grey),
                const SizedBox(width: 16),
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
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: 150.0,
      child: PagewiseListView<Actor>(
        pageSize: EventernoteService.pageSize,
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
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: 150.0,
      child: PagewiseListView<Actor>(
        pageSize: EventernoteService.pageSize,
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
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: 180.0,
      child: PagewiseListView<Event>(
        pageSize: EventernoteService.pageSize,
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
