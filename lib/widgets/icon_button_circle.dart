import 'package:flutter/material.dart';

class IconButtonCircle extends StatelessWidget {
  final Widget iconButton;

  /// A simple helper widget which wraps a [iconButton] in a40px diameter
  /// semi-transparent gray circle. Works best when [iconButton] is the default
  /// [iconSize] = 24.0.
  const IconButtonCircle(this.iconButton, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      width: 40.0,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0x3A000000),
        ),
        child: IconTheme(
          data: Theme.of(context).iconTheme.copyWith(color: Colors.white),
          child: iconButton,
        ),
      ),
    );
  }
}
