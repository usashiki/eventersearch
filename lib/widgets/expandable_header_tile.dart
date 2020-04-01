import 'package:animations/animations.dart';
import 'package:eventernote/widgets/header_tile.dart';
import 'package:flutter/material.dart';

class ExpandableHeaderTile extends StatelessWidget {
  final IconData icon;
  final Widget child;
  final Widget openWidget;

  ExpandableHeaderTile({
    @required this.icon,
    @required this.child,
    @required this.openWidget,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedElevation: 0.0,
      closedColor: Theme.of(context).canvasColor,
      closedBuilder: (context, open) => HeaderTile(
        icon: icon,
        child: child,
        onTap: open,
      ),
      openBuilder: (context, _) => openWidget,
    );
  }
}
