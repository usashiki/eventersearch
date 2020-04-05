import 'package:eventersearch/models/actor.dart';
import 'package:eventersearch/models/event.dart';
import 'package:eventersearch/services/eventernote_service.dart';
import 'package:eventersearch/services/favorites_state.dart';
import 'package:eventersearch/widgets/actor_tile.dart';
import 'package:eventersearch/widgets/event_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatefulWidget {
  /// A tabbed page with tabs for the user's favorite [Actor]s, those actors'
  /// events, and favotire [Event]s as stored in [FavoritesState].
  const FavoritesPage({Key key}) : super(key: key);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage>
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
          isScrollable: true,
          labelColor: Theme.of(context).textTheme.headline6.color,
          unselectedLabelColor: Theme.of(context).textTheme.caption.color,
          tabs: const <Widget>[
            Tab(text: '声優/ｱｰﾃｨｽﾄ'),
            Tab(text: '声優/ｱｰﾃｨｽﾄのイベント'),
            Tab(text: 'ノートしたイベント'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const <Widget>[
          _FavoriteActorTab(),
          _FavoriteActorEventsTab(),
          _FavoriteEventTab(),
        ],
      ),
    );
  }
}

class _FavoriteActorTab extends StatelessWidget {
  const _FavoriteActorTab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<FavoritesState, List<Actor>>(
      selector: (_, state) => state.favoriteActors,
      builder: (_, favoriteActors, __) {
        return ListView.separated(
          itemCount: favoriteActors.length,
          itemBuilder: (context, i) =>
              ActorTile(favoriteActors[i], showCount: false),
          separatorBuilder: (_, __) => const Divider(height: 0.5),
        );
      },
    );
  }
}

class _FavoriteActorEventsTab extends StatelessWidget {
  const _FavoriteActorEventsTab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<FavoritesState, List<Actor>>(
      selector: (_, state) => state.favoriteActors,
      builder: (_, favoriteActors, __) {
        if (favoriteActors.isEmpty) {
          return Container();
        }
        return PagewiseListView<Event>(
          pageSize: EventernoteService.pageSize,
          itemBuilder: (_, event, i) => Column(children: [
            EventTile(event, showCount: false),
            const Divider(height: 0.5),
          ]),
          pageFuture: (page) =>
              EventernoteService().getEventsForActors(favoriteActors, page),
        );
      },
    );
  }
}

class _FavoriteEventTab extends StatelessWidget {
  const _FavoriteEventTab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<FavoritesState, List<Event>>(
      selector: (_, state) => state.favoriteEvents,
      builder: (_, favoriteEvents, __) {
        return ListView.separated(
          itemCount: favoriteEvents.length,
          itemBuilder: (context, i) =>
              EventTile(favoriteEvents[i], showCount: false),
          separatorBuilder: (_, __) => const Divider(height: 0.5),
        );
      },
    );
  }
}
