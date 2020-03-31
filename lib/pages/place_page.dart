import 'package:auto_size_text/auto_size_text.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:eventernote/models/place.dart';
import 'package:eventernote/services/eventernote_service.dart';
import 'package:eventernote/widgets/event_tile.dart';
import 'package:eventernote/widgets/header_item.dart';
import 'package:eventernote/widgets/place_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:url_launcher/url_launcher.dart';

class PlacePage extends StatelessWidget {
  final Place place;

  const PlacePage(this.place, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: SliverAppBar? title?
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('会場情報'),
        actions: [
          IconButton(
            icon: Icon(CommunityMaterialIcons.web),
            tooltip: 'サイトで見る',
            onPressed: () async => await launch(place.eventernoteUrl),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(child: _PlaceHeader(place)),
          PagewiseSliverList(
            pageSize: EventernoteService.PAGE_SIZE,
            itemBuilder: (context, event, i) {
              return Column(
                children: <Widget>[
                  Divider(height: 0.5),
                  EventTile(event, animated: true),
                ],
              );
            },
            pageFuture: (page) =>
                EventernoteService().getEventsForPlace(place.id, page),
          ),
        ],
      ),
    );
  }
}

class _PlaceHeader extends StatelessWidget {
  final Place place;

  const _PlaceHeader(this.place, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: <Widget>[
              AutoSizeText(
                place.name,
                style: Theme.of(context).textTheme.title.copyWith(fontSize: 24),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ],
          ),
        ),
        PlaceMap(place),
        HeaderItem(
          icon: CommunityMaterialIcons.map_marker_outline,
          text: '${place.postalcode} ${place.address}',
          uri: place.geoUri,
        ),
        HeaderItem(
          icon: CommunityMaterialIcons.phone_outline,
          text: place.tel,
          uri: place.telUri,
        ),
        HeaderItem(
          icon: CommunityMaterialIcons.web,
          text: place.webUrl,
          uri: place.webUrl,
        ),
        HeaderItem(
          icon: CommunityMaterialIcons.account_group_outline,
          text: place.capacity,
        ),
        HeaderItem(
          icon: CommunityMaterialIcons.seat_outline,
          text: place.seatUrl,
          uri: place.seatUrl,
        ),
        HeaderItem(
          icon: Icons.info_outline,
          text: place.tips,
        ),
      ],
    );
  }
}
