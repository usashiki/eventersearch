import 'package:eventersearch/widgets/header_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class LaunchableHeaderTile extends StatelessWidget {
  /// Same as [HeaderTile.icon]. Required.
  final IconData icon;

  /// Same as [HeaderTile.child]. Required.
  final Widget child;

  /// The URI to launch on tap. Required.
  final String uri;

  /// If provided, the text to copy on long press.
  /// If not provided, [uri] is copied instead.
  final String copyableText; // if different from uri

  /// A [HeaderTile] with [icon] and [child] which can be tapped to launch [uri]
  /// and long-pressed to copy [copyableText] ([uri] if not present) to
  /// clipboard,
  LaunchableHeaderTile({
    @required this.icon,
    @required this.child,
    @required this.uri,
    this.copyableText,
    Key key,
  })  : assert(uri.isNotEmpty),
        assert(copyableText == null || copyableText.isNotEmpty),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return HeaderTile(
      icon: icon,
      onTap: () => launch(uri),
      onLongPress: () {
        debugPrint('copying ${copyableText ?? uri} to clipboard');
        Clipboard.setData(ClipboardData(text: copyableText ?? uri));
        Scaffold.of(context).showSnackBar(const SnackBar(
          content: Text('クリップボードにコピーしました。'),
          duration: Duration(seconds: 1),
        ));
      },
      child: child,
    );
  }
}
