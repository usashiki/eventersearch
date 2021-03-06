import 'package:auto_size_text/auto_size_text.dart';
import 'package:eventersearch/models/actor.dart';
import 'package:eventersearch/pages/actor_details_page.dart';
import 'package:eventersearch/widgets/actor_favorite_button.dart';
import 'package:flutter/material.dart';

class ActorTile extends StatelessWidget {
  final Actor actor;

  /// Whether the noteCount should be shown on trailing (right-hand) side of the
  /// tile. Defaults to true.
  /// If false, instead shows an [ActorFavoriteButton] to allow the user to
  /// favorite the actor.
  final bool showCount;

  /// A [ListTile] listing an [actor]'s name and reading with either the actor's
  /// number of fans or a favorite button trailing.
  /// When tapped opens an [ActorDetailsPage] for [actor].
  const ActorTile(
    this.actor, {
    this.showCount = true,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget trailing;
    if (showCount) {
      trailing = Container(
        constraints: const BoxConstraints(maxHeight: 35, maxWidth: 40),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(6)),
        ),
        child: Center(
          child: Text(
            '${actor.favoriteCount}',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    } else {
      trailing = ActorFavoriteButton(actor);
    }

    return ListTile(
      title: AutoSizeText(actor.name, maxLines: 1),
      subtitle: AutoSizeText(actor.kana, maxLines: 1),
      trailing: trailing,
      dense: true,
      onTap: () => Navigator.push<Widget>(
        context,
        MaterialPageRoute(builder: (context) => ActorDetailsPage(actor)),
      ),
    );
  }
}
