import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:eventersearch/models/actor.dart';
import 'package:eventersearch/pages/actor_page.dart';
import 'package:eventersearch/services/eventernote_service.dart';
import 'package:eventersearch/widgets/actor_favorite_button.dart';
import 'package:eventersearch/widgets/bold_number.dart';
import 'package:eventersearch/widgets/icon_button_circle.dart';
import 'package:flutter/material.dart';

class ActorCarouselCard extends StatelessWidget {
  final Actor actor;
  final int rank;

  const ActorCarouselCard(this.actor, {this.rank, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.0,
      padding: EdgeInsets.all(4.0),
      child: OpenContainer(
        closedColor: Theme.of(context).cardColor,
        closedElevation: 4.0,
        closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        closedBuilder: (context, open) {
          return Container(
            // color: Color(0x90F6C8DD), // TODO: color
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment(1.0, -1.0),
                        child: IconButtonCircle(ActorFavoriteButton(actor)),
                      ),
                      Align(
                        alignment: Alignment(-1.0, 1.0),
                        child: SizedBox(
                          height: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(maxHeight: 50),
                                child: AutoSizeText(
                                  rank != null
                                      ? '${rank + 1}. ${actor.name}'
                                      : actor.name,
                                  style: Theme.of(context).textTheme.headline6,
                                  maxLines: 2,
                                ),
                              ),
                              BoldNumber(
                                prefix: 'ファン',
                                number: '${actor.favoriteCount}',
                                suffix: '人',
                              ),
                              FutureBuilder<int>(
                                future: EventernoteService()
                                    .getNumEventsForActor(actor),
                                builder: (context, snapshot) {
                                  var text = '?';
                                  if (snapshot.hasData) {
                                    text = '${snapshot.data}';
                                  } else if (snapshot.hasError) {
                                    text = '-';
                                  }
                                  return BoldNumber(
                                    number: text,
                                    suffix: 'イベント',
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: open,
              ),
            ),
          );
        },
        openBuilder: (context, _) => ActorPage(actor),
      ),
    );
  }
}
