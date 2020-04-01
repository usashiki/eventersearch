import 'package:eventernote/widgets/date_text.dart';
import 'package:flutter/material.dart';
import 'package:eventernote/models/event.dart';
import 'package:eventernote/pages/event_page.dart';
import 'package:mdi/mdi.dart';

class EventSuggestionTile extends StatelessWidget {
  final Event event;

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
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EventPage(event)),
      ),
    );
  }
}
