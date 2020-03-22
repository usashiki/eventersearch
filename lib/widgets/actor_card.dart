import 'package:eventernote/models/actor.dart';
import 'package:flutter/material.dart';

class ActorCard extends StatelessWidget {
  final Actor actor;

  const ActorCard(this.actor, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      child: Card(
        elevation: 4,
        child: Text(actor.name),
      ),
    );
  }
}
