import 'package:animations/animations.dart';
import 'package:eventersearch/widgets/date_text.dart';
import 'package:eventersearch/widgets/event_favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:eventersearch/models/event.dart';
import 'package:eventersearch/pages/event_details_page.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EventTile extends StatelessWidget {
  final Event event;

  /// Whether the tile should be animated with [OpenContainer].
  /// Defaults to false.
  /// Because this includes an open and close animation, only use if the tile
  /// will still be present on close.
  final bool animated;

  /// Whether the date of the event should be displayed. Defaults to true.
  final bool showDate;

  /// Whether the time of the event should be displayed. Defaults to true.
  final bool showTime;

  /// Whether the place of the event should be displayed. Defaults to true.
  final bool showPlace;

  /// Whether the noteCount should be shown on trailing (right-hand) side of the
  /// tile. Defaults to true.
  /// If false, instead shows a star [IconButton] button to allow the user to
  /// favorite the event.
  final bool showCount;

  /// A [ListTile] listing an [event]'s name, and optionally date, time, and
  /// place, with either the number of attendees or a favorite button trailing.
  /// When tapped opens an [EventDetailsPage] for [event], optionally with an
  /// animation.
  const EventTile(
    this.event, {
    this.animated = false,
    this.showDate = true,
    this.showTime = true,
    this.showPlace = true,
    this.showCount = true,
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
          showPlace: showPlace,
        ),
        openBuilder: (context, _) => EventDetailsPage(event),
      );
    }
    return _BaseEventTile(
      event,
      showCount: showCount,
      showDate: showDate,
      showTime: showTime,
      showPlace: showPlace,
    );
  }
}

class _BaseEventTile extends StatelessWidget {
  final Event event;
  final VoidCallback tap;
  final bool showDate, showTime, showPlace, showCount;

  const _BaseEventTile(
    this.event, {
    this.tap,
    this.showDate,
    this.showTime,
    this.showPlace,
    this.showCount,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final info = <InlineSpan>[];
    if (showDate) {
      info.addAll([
        for (var t in DateText(event.date).spans) t,
        const TextSpan(text: '\n'),
      ]);
    }
    if (showTime) {
      info.addAll([
        TextSpan(text: event.timesString),
        const TextSpan(text: '\n'),
      ]);
    }
    if (showPlace) {
      info.add(TextSpan(text: event?.place?.name));
    }

    Widget trailing;
    if (showCount) {
      trailing = Container(
        constraints: const BoxConstraints(maxHeight: 35, maxWidth: 40),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: const BorderRadius.all(Radius.circular(6)),
        ),
        child: Center(
          child: Text(
            '${event.noteCount}',
            style: TextStyle(color: Colors.grey[900]),
          ),
        ),
      );
    } else {
      trailing = EventFavoriteButton(event);
    }

    return ListTile(
      leading: SizedBox(
        width: 60,
        height: 60,
        child: CachedNetworkImage(
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          imageUrl: event.thumbUrl,
          errorWidget: (context, url, error) => Icon(Icons.error),
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
          () => Navigator.push<Widget>(
                context,
                MaterialPageRoute(
                    builder: (context) => EventDetailsPage(event)),
              ),
    );
  }
}
