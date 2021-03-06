import 'package:eventersearch/widgets/date_text.dart';
import 'package:flutter/material.dart';
import 'package:eventersearch/models/event.dart';
import 'package:eventersearch/pages/event_details_page.dart';
import 'package:mdi/mdi.dart';

class EventSuggestionTile extends StatelessWidget {
  final Event event;

  /// A minimal [ListTile] listing an [event]'s name with a leading icon.
  const EventSuggestionTile(this.event, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Mdi.musicNoteOutline),
      title: Text(event.name),
      subtitle: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.caption,
          children: DateText(event.date).spans,
        ),
      ),
      dense: true,
      onTap: () => Navigator.push<Widget>(
        context,
        MaterialPageRoute(builder: (context) => EventDetailsPage(event)),
      ),
    );
  }
}
