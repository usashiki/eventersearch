import 'package:animations/animations.dart';
import 'package:eventernote/services/favorites_state.dart';
import 'package:eventernote/widgets/date_text.dart';
import 'package:flutter/material.dart';
import 'package:eventernote/models/event.dart';
import 'package:eventernote/pages/event_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

class EventTile extends StatelessWidget {
  final Event event;

  /// Whether the tile should be animated with OpenContainer. Defaults to false.
  /// Because this includes an open and close animation, only use if the tile
  /// will still be present on close.
  final bool animated;

  /// Whether the date of the event should be displayed. Defaults to true.
  final bool showDate;

  /// Whether the time of the event should be displayed. Defaults to true.
  final bool showTime;

  /// Whether the noteCount should be shown on trailing (right-hand) side of the
  /// tile. Defaults to true.
  /// If false, instead shows a star [IconButton] button to allow the user to
  /// favorite the event.
  final bool showCount;

  const EventTile(
    this.event, {
    this.animated = false,
    this.showCount = true,
    this.showDate = true,
    this.showTime = true,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (animated) {
      return OpenContainer(
        closedElevation: 0.0,
        closedColor: Theme.of(context).canvasColor,
        closedBuilder: (context, openContainer) => _BaseEventTile(
          event,
          tap: openContainer,
          showCount: showCount,
          showDate: showDate,
          showTime: showTime,
        ),
        openBuilder: (context, _) => EventPage(event),
      );
    }
    return _BaseEventTile(
      event,
      showCount: showCount,
      showDate: showDate,
      showTime: showTime,
    );
  }
}

class _BaseEventTile extends StatelessWidget {
  final Event event;
  final VoidCallback tap;
  final bool showCount, showDate, showTime;

  const _BaseEventTile(
    this.event, {
    this.tap,
    this.showCount,
    this.showDate,
    this.showTime,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final info = <InlineSpan>[];
    if (showDate) {
      info.addAll([
        for (var t in DateText(event.date).spans) t,
        TextSpan(text: '\n'),
      ]);
    }
    if (showTime) {
      info.addAll([
        TextSpan(text: event.timesString),
        TextSpan(text: '\n'),
      ]);
    }
    info.add(TextSpan(text: event?.place?.name));

    Widget trailing;
    if (showCount) {
      trailing = Container(
        constraints: BoxConstraints(maxHeight: 35, maxWidth: 40),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        child: Center(
          child: Text(
            '${event.noteCount}',
            style: TextStyle(color: Colors.grey[900]),
          ),
        ),
      );
    } else {
      trailing = Consumer<FavoritesState>(
        builder: (_, state, __) {
          if (state.containsEvent(event)) {
            return IconButton(
              icon: Icon(Icons.star, color: Colors.amber),
              onPressed: () => state.removeEvent(event),
            );
          }
          return IconButton(
            icon: Icon(Icons.star_border),
            onPressed: () => state.addEvent(event),
          );
        },
      );
    }

    return ListTile(
      leading: SizedBox(
        width: 60,
        height: 60,
        child: CachedNetworkImage(
          placeholder: (context, url) =>
              Center(child: CircularProgressIndicator()),
          imageUrl: event.thumbUrl,
          errorWidget: (context, url, error) {
            print(error);
            return Icon(Icons.error);
          },
        ),
      ),
      title: Text(event.name),
      subtitle: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.caption,
          children: info,
        ),
      ),
      isThreeLine: true,
      dense: true,
      trailing: trailing,
      onTap: tap ??
          () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EventPage(event)),
              ),
    );
  }
}
