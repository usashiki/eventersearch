import 'package:eventernote/services/eventernote_service.dart';
import 'package:eventernote/widgets/animated_actor_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';

class NewActorsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PagewiseListView(
      pageSize: EventernoteService.PAGE_SIZE,
      itemBuilder: (_, actor, i) {
        return Column(
          children: <Widget>[
            AnimatedActorTile(actor),
            Divider(height: 0.5),
          ],
        );
      },
      pageFuture: (page) => EventernoteService().getNewActors(page),
    );
  }
}
