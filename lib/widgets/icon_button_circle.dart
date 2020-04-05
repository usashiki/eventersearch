import 'package:flutter/material.dart';

class IconButtonCircle extends StatelessWidget {
  final Widget iconButton;

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
