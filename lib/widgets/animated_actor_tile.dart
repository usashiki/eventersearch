import 'package:animations/animations.dart';
import 'package:eventernote/models/actor.dart';
import 'package:eventernote/pages/actor_page.dart';
import 'package:eventernote/widgets/actor_tile.dart';
import 'package:flutter/material.dart';

class AnimatedActorTile extends StatelessWidget {
  final Actor actor;
  final bool expanded;
  final int rank; // if populated, prefix title with rank
  final int maxLines;

  AnimatedActorTile(
    this.actor, {
    this.rank,
    this.expanded: true,
    this.maxLines: 1,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedElevation: 0.0,
      closedColor: Theme.of(context).canvasColor,
      closedBuilder: (context, openContainer) => ActorTile(
        actor,
        rank: rank,
        expanded: expanded,
        maxLines: maxLines,
        tap: openContainer,
      ),
      openBuilder: (context, _) => ActorPage(actor),
    );
  }
}
