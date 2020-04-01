import 'package:flutter/material.dart';

class BoldNumber extends StatelessWidget {
  final String prefix, number, suffix;
  final TextStyle style;

  const BoldNumber({
    this.prefix,
    @required this.number,
    this.suffix,
    this.style,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<InlineSpan> spans = [];
    if (prefix != null) {
      spans.add(TextSpan(text: '$prefix '));
    }
    spans.add(TextSpan(
      text: number,
      style: TextStyle(fontWeight: FontWeight.bold),
    ));
    if (suffix != null) {
      spans.add(TextSpan(text: ' $suffix'));
    }
    return RichText(
      text: TextSpan(
        style: style ?? Theme.of(context).textTheme.body1,
        children: spans,
      ),
    );
  }
}
