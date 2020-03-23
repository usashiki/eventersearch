import 'package:animations/animations.dart';
import 'package:eventernote/models/actor.dart';
import 'package:eventernote/pages/actor_page.dart';
import 'package:flutter/material.dart';

class ActorCard extends StatelessWidget {
  final Actor actor;

  const ActorCard(this.actor, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      padding: EdgeInsets.all(4.0),
      child: OpenContainer(
        closedColor: Theme.of(context).cardColor,
        closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        closedElevation: 4.0,
        closedBuilder: (context, open) {
          return InkWell(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Text(actor.name),
            ),
            onTap: open,
          );
        },
        openBuilder: (context, _) => ActorPage(actor),
      ),
    );
  }
}
