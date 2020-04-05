import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';
import 'package:url_launcher/url_launcher.dart';

import 'icon_button_circle.dart';

class PageAppBar extends StatelessWidget {
  /// The url to open when the "open in browser" button on the right side of the
  /// app bar is pressed. Required.
  final String url;

  /// If provided, the widget which is displayed in 200px tall
  /// [FlexibleSpaceBar.background] of the expanded app bar.
  /// If not provided, the app bar is transparent and not expandable.
  final Widget background;

  /// A [SliverAppBar] with a close button on the left and an "open in browser"
  /// button on the right linking to [url]. Can optionally be provided with a
  /// [background] image.
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
        padding: const EdgeInsets.all(8),
        child: IconButtonCircle(IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        )),
      ),
      actions: <Widget>[
        IconButtonCircle(IconButton(
          icon: Icon(Mdi.web),
          tooltip: 'サイトで見る',
          onPressed: () => launch(url),
        )),
        const SizedBox(width: 8),
      ],
      expandedHeight: background != null ? 200.0 : null,
      stretch: true,
      flexibleSpace: FlexibleSpaceBar(background: background ?? Container()),
    );
  }
}
