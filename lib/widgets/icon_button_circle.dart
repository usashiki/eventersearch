import 'package:flutter/material.dart';

class IconButtonCircle extends StatelessWidget {
  final Icon icon;
  final String tooltip;
  final VoidCallback onPressed;

  const IconButtonCircle({
    @required this.icon,
    this.tooltip,
    this.onPressed,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36.0,
      width: 36.0,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0x3A000000),
        ),
        child: IconButton(
          padding: EdgeInsets.all(0.0),
          icon: icon,
          tooltip: tooltip,
          iconSize: 20.0,
          onPressed: onPressed ?? () {},
        ),
      ),
    );
  }
}
