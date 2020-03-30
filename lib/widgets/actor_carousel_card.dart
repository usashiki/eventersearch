import 'dart:math';

import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:eventernote/models/actor.dart';
import 'package:eventernote/pages/actor_page.dart';
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
          return InkWell(
            child: Container(
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
                        icon: Random().nextBool() // TODO: remove
                            ? Icon(Icons.favorite, color: Colors.red)
                            : Icon(
                                Icons.favorite_border,
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
                          rank != null
                              ? '${rank + 1}. ${actor.name}'
                              : actor.name,
                          style: Theme.of(context).textTheme.title,
                          maxLines: 2,
                        ),
                        Text('ファン: ${actor.favoriteCount}'),
                      ],
                    ),
                  )
                ],
              ),
            ),
            onTap: open,
          );
        },
        openBuilder: (context, close) => ActorPage(actor, close: close),
      ),
    );
  }
}
