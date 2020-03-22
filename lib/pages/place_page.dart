import 'package:auto_size_text/auto_size_text.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:eventernote/models/place.dart';
import 'package:eventernote/services/eventernote_service.dart';
import 'package:eventernote/widgets/animated_event_tile.dart';
import 'package:eventernote/widgets/place_map.dart';
import 'package:eventernote/widgets/text_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:url_launcher/url_launcher.dart';

class PlacePage extends StatelessWidget {
  final Place place;

  const PlacePage(this.place, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('会場情報'),
        actions: _actions(context),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(child: _headerCard(context)),
          PagewiseSliverList(
            pageSize: EventernoteService.PAGE_SIZE,
            itemBuilder: (context, event, i) {
              return Column(
                children: <Widget>[
                  Divider(height: 0.5),
                  AnimatedEventTile(event),
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

  List<Widget> _actions(BuildContext context) {
    var actions = [
      IconButton(
        icon: Icon(CommunityMaterialIcons.web),
        tooltip: 'サイトで見る',
        onPressed: () async => await launch(place.eventernoteUrl),
      ),
    ];

    if (place.seatUrl != null && place.seatUrl.isNotEmpty) {
      actions.add(IconButton(
        icon: Icon(Icons.event_seat),
        tooltip: '席表情報',
        onPressed: () async => await launch(place.seatUrl),
      ));
    }

    if (place.webUrl != null && place.webUrl.isNotEmpty) {
      actions.add(IconButton(
        icon: Icon(CommunityMaterialIcons.link_variant),
        tooltip: '公式サイト',
        onPressed: () async => await launch(place.webUrl),
      ));
    }

    if (place.tel != null && place.tel.isNotEmpty) {
      actions.add(IconButton(
        icon: Icon(Icons.phone),
        tooltip: '電話',
        onPressed: () async => await launch(place.telUri),
      ));
    }

    return actions;
  }

  Widget _headerCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: <Widget>[
                AutoSizeText(
                  place.name,
                  style: TextStyle(fontSize: 26.0),
                  maxLines: 1,
                ),
                AutoSizeText(
                  "${place.postalcode} ${place.address}",
                  style: Theme.of(context).textTheme.caption,
                  maxLines: 2,
                ),
              ],
            ),
          ),
          SizedBox(height: 4),
          SizedBox(
            height: 100,
            child: PlaceMap(place),
          ),
          ListTile(
            leading: Icon(CommunityMaterialIcons.account_group),
            title: Text('収容人数'),
            dense: true,
          ),
          TextBlock(place.capacity),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('会場TIPS'),
            dense: true,
          ),
          TextBlock(place.tips),
        ],
      ),
    );
  }
}
