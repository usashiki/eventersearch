import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';
import 'package:url_launcher/url_launcher.dart';

import 'icon_button_circle.dart';

class PageAppBar extends StatelessWidget {
  final String url;
  final Widget background;

  const PageAppBar({
    @required this.url,
    this.background,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      leading: Container(
        padding: EdgeInsets.all(10),
        child: IconButtonCircle(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      actions: <Widget>[
        IconButtonCircle(
          icon: Icon(Mdi.web),
          tooltip: 'サイトで見る',
          onPressed: () async => await launch(url),
        ),
        SizedBox(width: 10),
      ],
      expandedHeight: background != null ? 200.0 : null,
      stretch: true,
      flexibleSpace: FlexibleSpaceBar(background: background ?? Container()),
    );
  }
}
