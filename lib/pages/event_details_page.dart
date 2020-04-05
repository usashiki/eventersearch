import 'package:cached_network_image/cached_network_image.dart';
import 'package:eventersearch/models/event.dart';
import 'package:eventersearch/pages/actor_details_page.dart';
import 'package:eventersearch/pages/place_details_page.dart';
import 'package:eventersearch/services/favorites_state.dart';
import 'package:eventersearch/widgets/bold_number.dart';
import 'package:eventersearch/widgets/date_text.dart';
import 'package:eventersearch/widgets/expandable_header_tile.dart';
import 'package:eventersearch/widgets/header_tile.dart';
import 'package:eventersearch/widgets/details_header_title.dart';
import 'package:eventersearch/widgets/launchable_header_tile.dart';
import 'package:eventersearch/widgets/page_app_bar.dart';
import 'package:eventersearch/widgets/place_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mdi/mdi.dart';
import 'package:provider/provider.dart';

class EventDetailsPage extends StatelessWidget {
  final Event event;

  /// A page for showing the details for a specific [Event].
  const EventDetailsPage(this.event, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget fab = Consumer<FavoritesState>(builder: (context, state, __) {
      if (state.containsEvent(event)) {
        return SpeedDial(
          backgroundColor: Theme.of(context).canvasColor,
          children: [
            SpeedDialChild(
              child: Icon(Icons.cancel),
              backgroundColor: Colors.red,
              label: '参加しない(ノート削除)',
              labelStyle: Theme.of(context).textTheme.bodyText2,
              labelBackgroundColor: Theme.of(context).canvasColor,
              onTap: () => state.removeEvent(event),
            ),
            SpeedDialChild(
              child: Icon(Mdi.shareOutline),
              backgroundColor: Colors.green,
              label: '参加ツイートする',
              labelStyle: Theme.of(context).textTheme.bodyText2,
              labelBackgroundColor: Theme.of(context).canvasColor,
              onTap: () {},
            ),
            SpeedDialChild(
              child: Icon(Icons.edit),
              label: 'ノートを編集する',
              labelStyle: Theme.of(context).textTheme.bodyText2,
              labelBackgroundColor: Theme.of(context).canvasColor,
              onTap: () {},
            ),
          ],
          child: const Icon(Icons.star, color: Colors.amber, size: 28.0),
        );
      }
      return FloatingActionButton(
        backgroundColor: Theme.of(context).canvasColor,
        tooltip: '参加する(ノート作成)',
        onPressed: () => state.addEvent(event),
        child: Icon(
          Icons.star_border,
          color: Theme.of(context).textTheme.headline6.color,
        ),
      );
    });

    return Scaffold(
      floatingActionButton: fab,
      body: CustomScrollView(
        slivers: <Widget>[
          PageAppBar(
            url: event.eventernoteUrl,
            background: CachedNetworkImage(
              placeholder: (context, url) => Container(),
              imageUrl: event.imageUrl,
              alignment: Alignment.topCenter,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => Icon(Icons.error),
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
    final children = [
      const SizedBox(height: 4),
      DetailsHeaderTitle(event.name),
      HeaderTile(
        icon: Mdi.calendarOutline,
        child: DateText(
          event.date,
          style: Theme.of(context).textTheme.bodyText2,
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
        openWidget: PlaceDetailsPage(event.place),
        child: Text(event.place.name),
      ));
      if (event.place.latLng != null) {
        children.add(Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
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
      omitBottomPadding: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 4),
            child: BoldNumber(
              prefix: '出演者',
              number: '${event.actors.length}',
              suffix: '人',
            ),
          ),
          for (final actor in event.actors)
            ExpandableHeaderTile(
              icon: Icons.person_outline,
              openWidget: ActorDetailsPage(actor),
              trailing:
                  Provider.of<FavoritesState>(context).containsActor(actor)
                      ? Icon(Icons.favorite, color: Colors.red)
                      : null,
              child: Text(actor.name),
            ),
        ],
      ),
    ));

    for (final link in event.links) {
      if (link != null && link.isNotEmpty) {
        children.add(LaunchableHeaderTile(
          icon: Mdi.linkVariant,
          uri: link,
          child: Text(
            link,
            style: TextStyle(decoration: TextDecoration.underline),
          ),
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
        uri: event.hashtagUrl,
        copyableText: event.fullHashtag,
        child: Text(event.fullHashtag),
      ));
    }

    children.add(const SizedBox(height: 16));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}
