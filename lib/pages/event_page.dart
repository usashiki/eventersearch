import 'package:cached_network_image/cached_network_image.dart';
import 'package:eventernote/models/event.dart';
import 'package:eventernote/pages/actor_page.dart';
import 'package:eventernote/pages/place_page.dart';
import 'package:eventernote/widgets/bold_number.dart';
import 'package:eventernote/widgets/date_text.dart';
import 'package:eventernote/widgets/expandable_header_tile.dart';
import 'package:eventernote/widgets/header_tile.dart';
import 'package:eventernote/widgets/header_title.dart';
import 'package:eventernote/widgets/launchable_header_tile.dart';
import 'package:eventernote/widgets/page_app_bar.dart';
import 'package:eventernote/widgets/place_map.dart';
import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';

class EventPage extends StatelessWidget {
  final Event event;

  const EventPage(this.event, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          PageAppBar(
            url: event.eventernoteUrl,
            background: CachedNetworkImage(
              placeholder: (context, url) => Container(),
              imageUrl: event.imageUrl,
              alignment: Alignment.topCenter,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) {
                print(error);
                return Icon(Icons.error);
              },
            ),
          ),
          SliverToBoxAdapter(child: _EventHeader(event)),
        ],
      ),
    );
  }
}

class _EventHeader extends StatelessWidget {
  final Event event;

  const _EventHeader(this.event, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [
      SizedBox(height: 4),
      HeaderTitle(event.name),
      HeaderTile(
        icon: Mdi.calendarOutline,
        child: DateText(
          event.date,
          style: Theme.of(context).textTheme.body1,
        ),
      ),
      HeaderTile(
        icon: Mdi.clockOutline,
        child: Text(event.timesString),
      ),
    ];

    if (event.place != null) {
      children.add(ExpandableHeaderTile(
        icon: Mdi.mapMarkerOutline,
        child: Text(event.place.name),
        openWidget: PlacePage(event.place),
      ));
      if (event.place.latLng != null) {
        children.add(Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: SizedBox(height: 100, child: PlaceMap(event.place)),
        ));
      }
    }

    children.add(HeaderTile(
      icon: Mdi.fileAccountOutline,
      child: BoldNumber(
        prefix: 'イベンター',
        number: '${event.noteCount}',
        suffix: '人参加',
      ),
    ));

    children.add(HeaderTile(
      icon: Mdi.accountMultipleOutline,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 2, bottom: 4),
            child: BoldNumber(
              prefix: '出演者',
              number: '${event.actors.length}',
              suffix: '人',
            ),
          ),
          for (final actor in event.actors)
            ExpandableHeaderTile(
              icon: Icons.person_outline,
              child: Text(actor.name),
              openWidget: ActorPage(actor),
            ),
        ],
      ),
      omitBottomPadding: true,
    ));

    for (final link in event.links) {
      if (link != null && link.isNotEmpty) {
        children.add(LaunchableHeaderTile(
          icon: Mdi.linkVariant,
          child: Text(
            link,
            style: TextStyle(decoration: TextDecoration.underline),
          ),
          uri: link,
        ));
      }
    }

    if (event.description != null && event.description.isNotEmpty) {
      children.add(HeaderTile(
        icon: Mdi.informationOutline,
        child: Text(event.description),
      ));
    }

    if (event.hashtag != null && event.hashtag.isNotEmpty) {
      children.add(LaunchableHeaderTile(
        icon: Mdi.pound,
        child: Text('#${event.hashtag}'),
        uri: event.hashtagUrl,
        copyableText: '#${event.hashtag}',
      ));
    }

    children.add(SizedBox(height: 16));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}
