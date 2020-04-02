import 'package:eventernote/widgets/header_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class LaunchableHeaderTile extends StatelessWidget {
  final IconData icon;
  final Widget child;
  final String uri;
  final String copyableText; // if different from uri

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
      child: child,
      onTap: () async => await launch(uri),
      onLongPress: () {
        print('copying ${copyableText ?? uri} to clipboard');
        Clipboard.setData(ClipboardData(text: copyableText ?? uri));
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('クリップボードにコピーしました。'),
          duration: Duration(seconds: 1),
        ));
      },
    );
  }
}