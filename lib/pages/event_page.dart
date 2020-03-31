import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:eventernote/models/event.dart';
import 'package:eventernote/pages/place_page.dart';
import 'package:eventernote/widgets/actor_grid_card.dart';
import 'package:eventernote/widgets/date_text.dart';
import 'package:eventernote/widgets/header_item.dart';
import 'package:eventernote/widgets/place_map.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EventPage extends StatelessWidget {
  final Event event;
  final VoidCallback close;

  const EventPage(this.event, {this.close, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: close != null ? close : () => Navigator.pop(context),
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
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.75,
            ),
            delegate: SliverChildListDelegate([
              for (var actor in event.actors) ActorGridCard(actor),
            ]),
          ),
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
    return Column(
      children: [
        _ImageHeader(event.name, event.imageUrl),
        SizedBox(height: 8),
        HeaderItem(
          icon: CommunityMaterialIcons.calendar_today,
          text: event.date.toIso8601String(),
          // TODO: DateText...
        ),
        HeaderItem(
          icon: CommunityMaterialIcons.clock_outline,
          text: event.timesString,
        ),
        HeaderItem(
          icon: CommunityMaterialIcons.stadium,
          text: event.place.name,
          // TODO: OpenContainer into PlacePage
        ),
        PlaceMap(event.place, hideWhenNoLatLng: true),
        HeaderItem(
          icon: CommunityMaterialIcons.file_account,
          text: '${event.noteCount} イベンター参加',
          // TODO: bold eventers going?
        ),
        for (final link in event.links)
          HeaderItem(
              icon: CommunityMaterialIcons.link_variant, text: link, uri: link),
        HeaderItem(
          // TODO: hide/expand?
          icon: CommunityMaterialIcons.information_outline,
          text: event.description,
        ),
        HeaderItem(
          icon: CommunityMaterialIcons.pound,
          // TODO: handle this better
          text: event.hashtag != null && event.hashtag.isNotEmpty
              ? '#${event.hashtag}'
              : null,
          uri: event.hashtagUrl,
        ),
        HeaderItem(
          // TODO: dont really want this to be a header...
          icon: CommunityMaterialIcons.account_multiple_outline,
          text: '出演者',
        ),
      ],
    );
  }
}
