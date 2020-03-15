import 'package:community_material_icon/community_material_icon.dart';
import 'package:eventernote/services/eventernote_service.dart';
import 'package:eventernote/widgets/animated_actor_tile.dart';
import 'package:eventernote/widgets/fade_indexed_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';

class ActorRankingPage extends StatelessWidget with NavigationPage {
  String get title => '人気の声優/アーティストランキング';
  String get navTitle => 'ランキング';
  IconData get icon => CommunityMaterialIcons.crown;

  @override
  Widget build(BuildContext context) {
    return PagewiseListView(
      pageSize: EventernoteService.PAGE_SIZE,
      itemBuilder: (_, actor, i) {
        return Column(
          children: <Widget>[
            AnimatedActorTile(actor, rank: i + 1),
            Divider(height: 0.5),
          ],
        );
      },
      pageFuture: (page) => EventernoteService().getPopularActors(page),
    );
  }
}
