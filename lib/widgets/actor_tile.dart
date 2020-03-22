import 'package:auto_size_text/auto_size_text.dart';
import 'package:eventernote/models/actor.dart';
import 'package:eventernote/pages/actor_page.dart';
import 'package:flutter/material.dart';

class ActorTile extends StatelessWidget {
  final Actor actor;
  final bool expanded;
  final int rank; // if populated, prefix title with rank
  final int maxLines;
  final VoidCallback tap;

  ActorTile(
    this.actor, {
    this.rank,
    this.expanded = true,
    this.tap,
    this.maxLines = 1,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget subtitle, trailing;
    if (expanded) {
      subtitle = AutoSizeText(actor.kana, maxLines: 1);
      trailing = Container(
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
      );
    }

    return ListTile(
      title: AutoSizeText(
        expanded && rank != null ? "$rank. ${actor.name}" : actor.name,
        maxLines: maxLines,
      ),
      subtitle: subtitle,
      trailing: trailing,
      dense: true,
      onTap: tap != null
          ? tap
          : () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ActorPage(actor)),
              ),
    );
  }
}
