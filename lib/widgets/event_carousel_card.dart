import 'dart:math';

import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eventernote/models/event.dart';
import 'package:eventernote/pages/event_page.dart';
import 'package:flutter/material.dart';

class EventCarouselCard extends StatelessWidget {
  final Event event;

  const EventCarouselCard(this.event, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240.0,
      padding: EdgeInsets.all(4.0),
      child: OpenContainer(
        closedColor: Theme.of(context).cardColor,
        closedElevation: 4.0,
        closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        closedBuilder: (context, open) {
          return CachedNetworkImage(
            placeholder: (context, url) => _EventCarouselCardText(event, open),
            alignment: Alignment.topLeft,
            imageUrl: event.imageUrl,
            imageBuilder: (context, provider) {
              return Ink.image(
                image: provider,
                fit: BoxFit.cover,
                child: _EventCarouselCardText(event, open, background: true),
              );
            },
            fit: BoxFit.cover,
            errorWidget: (context, url, error) {
              print(error);
              return Icon(Icons.error);
            },
          );
        },
        openBuilder: (context, close) => EventPage(event, close: close),
      ),
    );
  }
}

class _EventCarouselCardText extends StatelessWidget {
  final Event event;
  final VoidCallback open;
  final bool background;

  const _EventCarouselCardText(
    this.event,
    this.open, {
    this.background = false,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment(0, -0.9),
                colors: <Color>[
                  Color(background ? 0xFF000000 : 0x00000000),
                  Color(0x00000000),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment(1.0, -1.0),
                  child: Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).canvasColor,
                    ),
                    child: IconButton(
                      padding: EdgeInsets.all(0.0),
                      icon: Random().nextBool() // TODO: remove rng
                          ? Icon(Icons.star, color: Colors.amber)
                          : Icon(
                              Icons.star_border,
                              color: Theme.of(context).textTheme.title.color,
                            ),
                      iconSize: 22.0,
                      onPressed: () {},
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment(-1.0, 1.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        event.name,
                        style: Theme.of(context)
                            .textTheme
                            .title
                            .copyWith(color: background ? Colors.white : null),
                        maxLines: 3,
                        presetFontSizes: [
                          Theme.of(context).textTheme.title.fontSize,
                        ],
                        overflow: TextOverflow.ellipsis,
                      ),
                      // AutoSizeText(event.place.name, maxLines: 1),
                      Text(
                        '参加イベンター: ${event.noteCount}',
                        style:
                            background ? TextStyle(color: Colors.white) : null,
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
      onTap: open,
    );
  }
}
