import 'package:auto_size_text/auto_size_text.dart';
import 'package:eventernote/models/place.dart';
import 'package:eventernote/services/eventernote_service.dart';
import 'package:eventernote/widgets/event_tile.dart';
import 'package:eventernote/widgets/header_tile.dart';
import 'package:eventernote/widgets/launchable_header_tile.dart';
import 'package:eventernote/widgets/place_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:mdi/mdi.dart';
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
            icon: Icon(Mdi.web),
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
    final List<Widget> children = [
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
    ];

    if (place.postalcode != null &&
        place.postalcode.isNotEmpty &&
        place.address != null &&
        place.address.isNotEmpty) {
      children.add(LaunchableHeaderTile(
        icon: Mdi.mapOutline,
        child: Text('${place.postalcode} ${place.address}'),
        uri: place.geoUri,
        copyableText: '${place.postalcode} ${place.address}',
      ));
      children.add(PlaceMap(place));
    }

    if (place.tel != null && place.tel.isNotEmpty) {
      children.add(LaunchableHeaderTile(
        icon: Mdi.phoneOutline,
        child: Text(place.tel),
        uri: place.telUri,
        copyableText: place.tel,
      ));
    }

    if (place.webUrl != null && place.webUrl.isNotEmpty) {
      children.add(LaunchableHeaderTile(
        icon: Mdi.web,
        child: Text(
          place.webUrl,
          style: TextStyle(decoration: TextDecoration.underline),
        ),
        uri: place.webUrl,
      ));
    }

    if (place.capacity != null && place.capacity.isNotEmpty) {
      children.add(HeaderTile(
        icon: Mdi.accountGroupOutline,
        child: Text(place.capacity),
      ));
    }

    if (place.seatUrl != null && place.seatUrl.isNotEmpty) {
      children.add(LaunchableHeaderTile(
        icon: Mdi.seatOutline,
        child: Text(
          place.seatUrl,
          style: TextStyle(decoration: TextDecoration.underline),
        ),
        uri: place.seatUrl,
      ));
    }

    if (place.tips != null && place.tips.isNotEmpty) {
      children.add(HeaderTile(
        icon: Icons.info_outline,
        child: Text(place.tips),
      ));
    }

    return Column(children: children);
  }
}
