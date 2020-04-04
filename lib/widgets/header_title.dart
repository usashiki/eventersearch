import 'package:flutter/material.dart';

class HeaderTitle extends StatelessWidget {
  final String text;

  const HeaderTitle(this.text, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Text(text, style: Theme.of(context).textTheme.headline6),
    );
  }
}
