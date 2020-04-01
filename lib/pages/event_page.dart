import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:eventernote/models/event.dart';
import 'package:eventernote/pages/actor_page.dart';
import 'package:eventernote/pages/place_page.dart';
import 'package:eventernote/widgets/bold_number.dart';
import 'package:eventernote/widgets/date_text.dart';
import 'package:eventernote/widgets/expandable_header_tile.dart';
import 'package:eventernote/widgets/header_tile.dart';
import 'package:eventernote/widgets/launchable_header_tile.dart';
import 'package:eventernote/widgets/place_map.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EventPage extends StatelessWidget {
  final Event event;

  const EventPage(this.event, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('イベント情報'),
          actions: [
            IconButton(
              icon: Icon(CommunityMaterialIcons.web),
              tooltip: 'サイトで見る',
              onPressed: () async => await launch(event.eventernoteUrl),
            ),
          ]),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(child: _EventHeader(event)),
        ],
      ),
    );
  }
}

// TODO: rework image header
class _ImageHeader extends StatelessWidget {
  final String name, imageUrl;

  const _ImageHeader(this.name, this.imageUrl, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          CachedNetworkImage(
            placeholder: (context, url) => Container(),
            imageUrl: imageUrl,
            alignment: Alignment.topLeft,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) {
              print(error);
              return Icon(Icons.error);
            },
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment(0, -0.2),
                colors: <Color>[Color(0xFF000000), Color(0x00000000)],
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.all(10),
            child: AutoSizeText(
              name,
              maxLines: 3,
              style: Theme.of(context)
                  .textTheme
                  .title
                  .copyWith(color: Colors.white),
            ),
          ),
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
      _ImageHeader(event.name, event.imageUrl),
      SizedBox(height: 8),
      HeaderTile(
        icon: CommunityMaterialIcons.calendar_today,
        child: DateText(
          event.date,
          style: Theme.of(context).textTheme.body1,
        ),
      ),
      HeaderTile(
        icon: CommunityMaterialIcons.clock_outline,
        child: Text(event.timesString),
      ),
    ];

    if (event.place != null) {
      children.add(ExpandableHeaderTile(
        icon: CommunityMaterialIcons.stadium,
        child: Text(event.place.name),
        openWidget: PlacePage(event.place),
      ));
      if (event.place.latLng != null) {
        children.add(PlaceMap(event.place));
      }
    }

    children.add(HeaderTile(
      icon: CommunityMaterialIcons.file_account,
      child: BoldNumber(
        prefix: 'イベンター',
        number: '${event.noteCount}',
        suffix: '人参加',
      ),
    ));

    children.add(HeaderTile(
      icon: CommunityMaterialIcons.account_multiple_outline,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2),
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
    ));
    // TODO: padding here is a bit off because HeaderTiles are already padded

    for (final link in event.links) {
      if (link != null && link.isNotEmpty) {
        children.add(LaunchableHeaderTile(
          icon: CommunityMaterialIcons.link_variant,
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
        icon: CommunityMaterialIcons.information_outline,
        child: Text(event.description),
      ));
    }

    if (event.hashtag != null && event.hashtag.isNotEmpty) {
      children.add(LaunchableHeaderTile(
        icon: CommunityMaterialIcons.pound,
        child: Text('#${event.hashtag}'),
        uri: event.hashtagUrl,
        copyableText: '#${event.hashtag}',
      ));
    }

    return Column(children: children);
  }
}
