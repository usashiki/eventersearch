import 'package:auto_size_text/auto_size_text.dart';
import 'package:eventernote/models/actor.dart';
import 'package:eventernote/services/eventernote_service.dart';
import 'package:eventernote/widgets/event_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:mdi/mdi.dart';
import 'package:url_launcher/url_launcher.dart';

class ActorPage extends StatelessWidget {
  final Actor actor;

  const ActorPage(this.actor, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('声優/アーティスト情報'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Mdi.web),
            tooltip: 'サイトで見る',
            onPressed: () async => await launch(actor.eventernoteUrl),
          ),
          IconButton(
            icon: Icon(Mdi.wikipedia),
            tooltip: 'Wikipedia',
            onPressed: () async => await launch(actor.wikiUrl),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(child: _header(context)),
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

  Widget _header(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          AutoSizeText(
            actor.name,
            style: TextStyle(fontSize: 26.0),
            maxLines: 1,
          ),
          AutoSizeText(
            actor.kana,
            style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
            maxLines: 1,
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "${actor.favoriteCount}",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('ファン'),
                ],
              ),
              Column(
                children: <Widget>[
                  FutureBuilder<int>(
                    future: EventernoteService().getNumEventsForActor(actor.id),
                    builder: (context, snapshot) {
                      var text = '?';
                      if (snapshot.hasData) {
                        text = "${snapshot.data}";
                      } else if (snapshot.hasError) {
                        text = '-';
                      }
                      return Text(
                        text,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                  Text('イベント'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
