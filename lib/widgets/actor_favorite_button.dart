import 'package:eventersearch/models/actor.dart';
import 'package:eventersearch/services/favorites_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActorFavoriteButton extends StatelessWidget {
  final Actor actor;

  ActorFavoriteButton(this.actor, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesState>(
      builder: (_, state, __) {
        if (state.containsActor(actor)) {
          return IconButton(
            icon: Icon(Icons.favorite, color: Colors.red),
            onPressed: () => state.removeActor(actor),
            tooltip: 'お気に入り声優/アーティストから外す',
          );
        }
        return IconButton(
          icon: Icon(Icons.favorite_border),
          onPressed: () => state.addActor(actor),
          tooltip: 'お気に入り声優/ｱｰﾃｨｽﾄに登録する',
        );
      },
    );
  }
}
