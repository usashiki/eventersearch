import 'package:flutter/material.dart';

class TextBlock extends StatelessWidget {
  final String text;

  const TextBlock(this.text, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: RichText(
        text: TextSpan(
          text: text == null || text.isEmpty ? 'N/A' : text,
          style: Theme.of(context).textTheme.caption,
        ),
      ),
    );
  }
}
