import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class HeaderItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final String uri;

  const HeaderItem({
    this.icon,
    this.text,
    this.uri,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (text == null || text.isEmpty) {
      return Container();
    }

    VoidCallback onTap, onLongPress;
    if (uri != null) {
      onTap = () async => await launch(uri);
      onLongPress = () {
        Clipboard.setData(ClipboardData(text: text));
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Copied to clipboard'),
          duration: Duration(seconds: 1),
        ));
      };
    }

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: Icon(icon, color: Colors.grey),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(text),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
