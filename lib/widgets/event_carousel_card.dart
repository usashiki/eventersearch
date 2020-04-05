import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eventersearch/models/event.dart';
import 'package:eventersearch/pages/event_page.dart';
import 'package:eventersearch/widgets/bold_number.dart';
import 'package:eventersearch/widgets/event_favorite_button.dart';
import 'package:eventersearch/widgets/icon_button_circle.dart';
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
            alignment: Alignment.topLeft,
            imageUrl: event.imageUrl,
            placeholder: (context, url) => _EventCarouselCardText(event, open),
            imageBuilder: (context, provider) {
              return Ink.image(
                image: provider,
                fit: BoxFit.cover,
                child: _EventCarouselCardText(event, open, background: true),
              );
            },
          );
        },
        openBuilder: (context, _) => EventPage(event),
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
                  child: IconButtonCircle(EventFavoriteButton(event)),
                ),
                Align(
                  alignment: Alignment(-1.0, 1.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AutoSizeText(
                        event.name,
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(color: background ? Colors.white : null),
                        maxLines: 3,
                        presetFontSizes: [
                          Theme.of(context).textTheme.headline6.fontSize,
                        ],
                        overflow: TextOverflow.ellipsis,
                      ),
                      BoldNumber(
                        prefix: 'イベンター',
                        number: '${event.noteCount}',
                        suffix: '人参加',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(color: background ? Colors.white : null),
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
