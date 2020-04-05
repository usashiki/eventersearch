import 'package:animations/animations.dart';
import 'package:eventersearch/widgets/header_tile.dart';
import 'package:flutter/material.dart';

class ExpandableHeaderTile extends StatelessWidget {
  final IconData icon;
  final Widget child, openWidget, trailing;

  const ExpandableHeaderTile({
    @required this.icon,
    @required this.child,
    @required this.openWidget,
    this.trailing,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      // closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      closedElevation: 0.0,
      closedColor: Theme.of(context).canvasColor,
      closedBuilder: (context, open) =>
          HeaderTile(icon: icon, onTap: open, trailing: trailing, child: child),
      openBuilder: (context, _) => openWidget,
    );
  }
}
