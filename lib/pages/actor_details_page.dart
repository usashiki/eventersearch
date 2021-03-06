import 'package:eventersearch/models/actor.dart';
import 'package:eventersearch/models/event.dart';
import 'package:eventersearch/services/eventernote_service.dart';
import 'package:eventersearch/services/favorites_state.dart';
import 'package:eventersearch/widgets/bold_number.dart';
import 'package:eventersearch/widgets/event_tile.dart';
import 'package:eventersearch/widgets/header_tile.dart';
import 'package:eventersearch/widgets/details_header_title.dart';
import 'package:eventersearch/widgets/page_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:mdi/mdi.dart';
import 'package:provider/provider.dart';

class ActorDetailsPage extends StatelessWidget {
  final Actor actor;

  /// A page for showing the details for a specific [Actor], along with [Event]s
  /// they are performing in.
  const ActorDetailsPage(this.actor, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget fab = Consumer<FavoritesState>(
      builder: (_, state, __) {
        if (state.containsActor(actor)) {
          return FloatingActionButton(
            backgroundColor: Theme.of(context).canvasColor,
            tooltip: 'お気に入り声優/アーティストから外す',
            onPressed: () => state.removeActor(actor),
            child: Icon(Icons.favorite, color: Colors.red),
          );
        }
        return FloatingActionButton(
          backgroundColor: Theme.of(context).canvasColor,
          tooltip: 'お気に入り声優/ｱｰﾃｨｽﾄに登録する',
          onPressed: () => state.addActor(actor),
          child: Icon(
            Icons.favorite_border,
            color: Theme.of(context).textTheme.headline6.color,
          ),
        );
      },
    );

    return Scaffold(
      floatingActionButton: fab,
      body: CustomScrollView(
        slivers: <Widget>[
          PageAppBar(url: actor.eventernoteUrl),
          SliverToBoxAdapter(child: _ActorHeader(actor)),
          PagewiseSliverList<Event>(
            pageSize: EventernoteService.pageSize,
            itemBuilder: (context, event, i) {
              return Column(
                children: <Widget>[
                  const Divider(height: 0.5),
                  EventTile(event, animated: true),
                ],
              );
            },
            pageFuture: (page) =>
                EventernoteService().getEventsForActor(actor, page),
          ),
        ],
      ),
    );
  }
}

class _ActorHeader extends StatelessWidget {
  final Actor actor;

  const _ActorHeader(this.actor, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DetailsHeaderTitle(actor.name),
        HeaderTile(
          icon: Mdi.syllabaryHiragana,
          child: Text(actor.kana),
        ),
        HeaderTile(
          icon: Mdi.heartMultipleOutline,
          child: BoldNumber(
            prefix: 'ファン',
            number: '${actor.favoriteCount}',
            suffix: '人',
          ),
        ),
        HeaderTile(
          icon: Mdi.musicNoteOutline,
          child: FutureBuilder<int>(
            future: EventernoteService().getNumEventsForActor(actor),
            builder: (_, ss) => BoldNumber(
              number: futureInt(ss),
              suffix: 'イベント',
            ),
          ),
        ),
      ],
    );
  }
}
