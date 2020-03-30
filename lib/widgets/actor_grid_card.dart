import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:eventernote/models/actor.dart';
import 'package:eventernote/pages/actor_page.dart';
import 'package:flutter/material.dart';

class ActorGridCard extends StatelessWidget {
  final Actor actor;

  const ActorGridCard(this.actor, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.0),
      child: OpenContainer(
        closedColor: Theme.of(context).cardColor,
        closedElevation: 4.0,
        closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        closedBuilder: (context, open) {
          return InkWell(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: AutoSizeText(actor.name, maxLines: 3),
            ),
            onTap: open,
          );
        },
        openBuilder: (context, close) => ActorPage(actor, close: close),
      ),
    );
  }
}
