import 'package:eventersearch/models/event.dart';
import 'package:eventersearch/models/place.dart';
import 'package:eventersearch/services/eventernote_service.dart';
import 'package:eventersearch/widgets/event_tile.dart';
import 'package:eventersearch/widgets/header_tile.dart';
import 'package:eventersearch/widgets/details_header_title.dart';
import 'package:eventersearch/widgets/launchable_header_tile.dart';
import 'package:eventersearch/widgets/page_app_bar.dart';
import 'package:eventersearch/widgets/place_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:mdi/mdi.dart';

class PlaceDetailsPage extends StatelessWidget {
  final Place place;

  /// A page for showing the details for a specific [Place], along with [Event]s
  /// taking place at that place.
  const PlaceDetailsPage(this.place, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          PageAppBar(
            url: place.eventernoteUrl,
            background: place.latLng == null ? null : PlaceMap(place),
          ),
          SliverToBoxAdapter(child: _PlaceHeader(place)),
          PagewiseSliverList<Event>(
            pageSize: EventernoteService.pageSize,
            itemBuilder: (context, event, i) {
              return Column(
                children: <Widget>[
                  const Divider(height: 0.5),
                  EventTile(event, animated: true, showPlace: false),
                ],
              );
            },
            pageFuture: (page) =>
                EventernoteService().getEventsForPlace(place, page),
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
    final children = [
      const SizedBox(height: 4),
      DetailsHeaderTitle(place.name),
    ];

    if (place.postalcode != null &&
        place.postalcode.isNotEmpty &&
        place.address != null &&
        place.address.isNotEmpty) {
      children.add(LaunchableHeaderTile(
        icon: Mdi.mapOutline,
        uri: place.geoUri,
        copyableText: '${place.postalcode} ${place.address}',
        child: Text('${place.postalcode} ${place.address}'),
      ));
      // children.add(PlaceMap(place));
    }

    if (place.tel != null && place.tel.isNotEmpty) {
      children.add(LaunchableHeaderTile(
        icon: Mdi.phoneOutline,
        uri: place.telUri,
        copyableText: place.tel,
        child: Text(place.tel),
      ));
    }

    if (place.webUrl != null && place.webUrl.isNotEmpty) {
      children.add(LaunchableHeaderTile(
        icon: Mdi.web,
        uri: place.webUrl,
        child: Text(
          place.webUrl,
          style: TextStyle(decoration: TextDecoration.underline),
        ),
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
        uri: place.seatUrl,
        child: Text(
          place.seatUrl,
          style: TextStyle(decoration: TextDecoration.underline),
        ),
      ));
    }

    if (place.tips != null && place.tips.isNotEmpty) {
      children.add(HeaderTile(
        icon: Icons.info_outline,
        child: Text(place.tips),
      ));
    }

    children.add(const SizedBox(height: 12));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}
