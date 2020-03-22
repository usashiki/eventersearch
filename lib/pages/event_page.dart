import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:eventernote/models/event.dart';
import 'package:eventernote/pages/place_page.dart';
import 'package:eventernote/widgets/animated_actor_tile.dart';
import 'package:eventernote/widgets/date_text.dart';
import 'package:eventernote/widgets/place_map.dart';
import 'package:eventernote/widgets/text_block.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EventPage extends StatelessWidget {
  final Event event;
  final Color color;

  EventPage(this.event, {this.color, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('イベント情報'),
        actions: _actions(context),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: _imageHeader(context),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                ListTile(
                  leading: Icon(CommunityMaterialIcons.calendar),
                  title: DateText(event.date,
                      style: Theme.of(context).textTheme.body1),
                  dense: true,
                ),
                ListTile(
                  leading: Icon(CommunityMaterialIcons.clock_outline),
                  title: Text(event.timesString),
                  dense: true,
                ),
                OpenContainer(
                  closedElevation: 0.0,
                  closedColor: Theme.of(context).canvasColor,
                  closedBuilder: (context, openContainer) {
                    return ListTile(
                      leading: Icon(CommunityMaterialIcons.map_marker_outline),
                      title: Text(event.place.name),
                      dense: true,
                      onTap: openContainer,
                    );
                  },
                  openBuilder: (context, _) => PlacePage(event.place),
                ),
                SizedBox(
                  height:
                      event.place.latitude == 0 && event.place.longitude == 0
                          ? 0
                          : 100,
                  child: PlaceMap(event.place, color: color),
                ),
                ListTile(
                  leading: Icon(CommunityMaterialIcons.file_account),
                  title: Text("参加のイベンター (${event.noteCount})"),
                  dense: true,
                ),
                ListTile(
                  leading: Icon(Icons.info),
                  title: Text('概要'),
                  dense: true,
                ),
                TextBlock(event.description),
                SizedBox(height: 12),
                ListTile(
                  leading: Icon(CommunityMaterialIcons.account_multiple),
                  title: Text('出演者'),
                  dense: true,
                ),
              ],
            ),
          ),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2,
            ),
            delegate: SliverChildListDelegate([
              for (var actor in event.actors)
                Card(
                  elevation: 3.0,
                  child: AnimatedActorTile(actor, expanded: false, maxLines: 2),
                ),
            ]),
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
        onPressed: () async => await launch(event.eventernoteUrl),
      ),
    ];

    if (event.link != null && event.link.isNotEmpty) {
      actions.add(IconButton(
        icon: Icon(CommunityMaterialIcons.link_variant),
        tooltip: "関連リンク (${event.links.length})",
        onPressed: () async {
          if (event.links.length == 1) {
            await launch(event.link);
          } else {
            await showDialog(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  children: <Widget>[
                    for (String url in event.links)
                      SimpleDialogOption(
                        onPressed: () async => await launch(url),
                        child: Text(url),
                      )
                  ],
                );
              },
            );
          }
        },
      ));
    }

    if (event.hashtag != null && event.hashtag.isNotEmpty) {
      actions.add(IconButton(
        icon: Icon(CommunityMaterialIcons.pound),
        tooltip: 'Twitterハッシュタグ',
        onPressed: () async => await launch(event.hashtagUrl),
      ));
    }

    return actions;
  }

  Widget _imageHeader(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          CachedNetworkImage(
            placeholder: (context, url) => Container(),
            imageUrl: event.imageUrl,
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
              event.name,
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
