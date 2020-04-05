import 'package:eventersearch/models/event.dart';
import 'package:eventersearch/services/favorites_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventFavoriteButton extends StatelessWidget {
  final Event event;

  const EventFavoriteButton(this.event, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesState>(
      builder: (_, state, __) {
        if (state.containsEvent(event)) {
          return IconButton(
            icon: const Icon(Icons.star, color: Colors.amber),
            onPressed: () => state.removeEvent(event),
            tooltip: '参加しない(ノート削除)',
          );
        }
        return IconButton(
          icon: const Icon(Icons.star_border),
          onPressed: () => state.addEvent(event),
          tooltip: '参加する(ノート作成)',
        );
      },
    );
  }
}
