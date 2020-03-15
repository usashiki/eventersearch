import 'package:eventernote/widgets/date_text.dart';
import 'package:flutter/material.dart';
import 'package:eventernote/models/event.dart';
import 'package:eventernote/pages/event_page.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EventTile extends StatelessWidget {
  final Event event;
  final bool expanded;
  final VoidCallback tap;

  EventTile(this.event, {this.expanded: true, this.tap, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget leading, title, subtitle;
    if (expanded) {
      leading = SizedBox(
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
      );
      title = Text(event.name);
      subtitle = RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.caption,
          children: [
            for (var t in DateText(event.date).spans()) t,
            TextSpan(text: '\n'),
            TextSpan(text: event.timesString),
            TextSpan(text: '\n'),
            TextSpan(text: event?.place?.name),
          ],
        ),
      );
    } else {
      title = RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.body1,
          children: [
            for (var t in DateText(event.date).spans()) t,
            TextSpan(text: " ${event.name}"),
          ],
        ),
      );
    }

    return ListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      isThreeLine: expanded,
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
