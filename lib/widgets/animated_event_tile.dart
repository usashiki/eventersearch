import 'package:animations/animations.dart';
import 'package:eventernote/models/event.dart';
import 'package:eventernote/pages/event_page.dart';
import 'package:eventernote/widgets/event_tile.dart';
import 'package:flutter/material.dart';

class AnimatedEventTile extends StatelessWidget {
  final Event event;
  final bool expanded;

  AnimatedEventTile(this.event, {this.expanded: true, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedElevation: 0.0,
      closedColor: Theme.of(context).canvasColor,
      closedBuilder: (context, openContainer) =>
          EventTile(event, expanded: expanded, tap: openContainer),
      openBuilder: (context, _) => EventPage(event),
    );
  }
}
