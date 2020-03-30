import 'package:auto_size_text/auto_size_text.dart';
import 'package:eventernote/models/actor.dart';
import 'package:eventernote/pages/actor_page.dart';
import 'package:flutter/material.dart';

class ActorSuggestionTile extends StatelessWidget {
  final Actor actor;

  const ActorSuggestionTile(this.actor, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.person),
      title: AutoSizeText(actor.name, maxLines: 1),
      dense: true,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ActorPage(actor)),
      ),
    );
  }
}
