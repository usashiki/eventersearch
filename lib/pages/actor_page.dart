import 'package:eventernote/models/actor.dart';
import 'package:eventernote/services/eventernote_service.dart';
import 'package:eventernote/widgets/bold_number.dart';
import 'package:eventernote/widgets/event_tile.dart';
import 'package:eventernote/widgets/header_tile.dart';
import 'package:eventernote/widgets/header_title.dart';
import 'package:eventernote/widgets/page_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:mdi/mdi.dart';

class ActorPage extends StatelessWidget {
  final Actor actor;

  const ActorPage(this.actor, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          PageAppBar(url: actor.eventernoteUrl),
          SliverToBoxAdapter(child: _ActorHeader(actor)),
          PagewiseSliverList(
            pageSize: EventernoteService.PAGE_SIZE,
            itemBuilder: (context, event, i) {
              return Column(
                children: <Widget>[
                  Divider(height: 0.5),
                  EventTile(event, animated: true),
                ],
              );
            },
            pageFuture: (page) =>
                EventernoteService().getEventsForActor(actor.id, page),
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
        HeaderTitle(actor.name),
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
            future: EventernoteService().getNumEventsForActor(actor.id),
            builder: (context, snapshot) {
              var text = '?';
              if (snapshot.hasData) {
                text = "${snapshot.data}";
              } else if (snapshot.hasError) {
                text = '-';
              }
              return BoldNumber(
                number: text,
                suffix: 'イベント',
              );
            },
          ),
        ),
      ],
    );
  }
}
