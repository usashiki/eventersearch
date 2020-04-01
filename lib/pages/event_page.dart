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
import 'package:eventernote/widgets/icon_button_circle.dart';
import 'package:eventernote/widgets/launchable_header_tile.dart';
import 'package:eventernote/widgets/place_map.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// TODO: color of appbar based on image?
// TODO: inkwell in expanded appbar?
class EventPage extends StatelessWidget {
  final Event event;

  const EventPage(this.event, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            leading: Container(
              padding: EdgeInsets.all(8),
              child: IconButtonCircle(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: <Widget>[
              IconButtonCircle(
                icon: Icon(CommunityMaterialIcons.web),
                tooltip: 'サイトで見る',
                onPressed: () async => await launch(event.eventernoteUrl),
              ),
              SizedBox(width: 6),
            ],
            expandedHeight: 200.0,
            pinned: false,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              title: AutoSizeText(
                event.name,
                maxFontSize: 16,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              centerTitle: true,
              titlePadding:
                  EdgeInsets.symmetric(horizontal: 80).copyWith(bottom: 16),
              background: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  CachedNetworkImage(
                    placeholder: (context, url) => Container(),
                    imageUrl: event.imageUrl,
                    alignment: Alignment.topCenter,
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
                ],
              ),
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

    children.add(SizedBox(height: 16));

    return Column(children: children);
  }
}
