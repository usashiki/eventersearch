import 'package:animations/animations.dart';
import 'package:eventernote/widgets/date_text.dart';
import 'package:flutter/material.dart';
import 'package:eventernote/models/event.dart';
import 'package:eventernote/pages/event_page.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EventTile extends StatelessWidget {
  final Event event;
  final bool animated;

  const EventTile(this.event, {this.animated = false, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (animated) {
      return OpenContainer(
        closedElevation: 0.0,
        closedColor: Theme.of(context).canvasColor,
        closedBuilder: (context, openContainer) =>
            _BaseEventTile(event, tap: openContainer),
        openBuilder: (context, _) => EventPage(event),
      );
    }
    return _BaseEventTile(event);
  }
}

class _BaseEventTile extends StatelessWidget {
  final Event event;
  final VoidCallback tap;

  const _BaseEventTile(this.event, {this.tap, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          children: [
            for (var t in DateText(event.date).spans) t,
            TextSpan(text: '\n'),
            TextSpan(text: event.timesString),
            TextSpan(text: '\n'),
            TextSpan(text: event?.place?.name),
          ],
        ),
      ),
      isThreeLine: true,
      dense: true,
      onTap: tap != null
          ? tap
          : () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EventPage(event)),
              ),
    );
  }
}
