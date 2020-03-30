import 'package:auto_size_text/auto_size_text.dart';
import 'package:eventernote/models/actor.dart';
import 'package:eventernote/pages/actor_page.dart';
import 'package:flutter/material.dart';

class ActorTile extends StatelessWidget {
  final Actor actor;

  const ActorTile(this.actor, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: AutoSizeText(actor.name, maxLines: 1),
      subtitle: AutoSizeText(actor.kana, maxLines: 1),
      trailing: Container(
        constraints: BoxConstraints(maxHeight: 35, maxWidth: 40),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        child: Center(
          child: Text(
            actor.favoriteCount.toString(),
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      dense: true,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ActorPage(actor)),
      ),
    );
  }
}
