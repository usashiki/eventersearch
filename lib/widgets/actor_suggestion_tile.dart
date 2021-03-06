import 'package:auto_size_text/auto_size_text.dart';
import 'package:eventersearch/models/actor.dart';
import 'package:eventersearch/pages/actor_details_page.dart';
import 'package:flutter/material.dart';

class ActorSuggestionTile extends StatelessWidget {
  final Actor actor;

  /// A minimal [ListTile] listing an [actor]'s name with a keading icon.
  const ActorSuggestionTile(this.actor, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.person_outline),
      title: AutoSizeText(actor.name, maxLines: 1),
      dense: true,
      onTap: () => Navigator.push<Widget>(
        context,
        MaterialPageRoute(builder: (context) => ActorDetailsPage(actor)),
      ),
    );
  }
}
