import 'package:animations/animations.dart';
import 'package:eventersearch/widgets/header_tile.dart';
import 'package:flutter/material.dart';

class ExpandableHeaderTile extends StatelessWidget {
  /// Same as [HeaderTile.icon]. Required.
  final IconData icon;

  /// Same as [HeaderTile.child]. Required.
  final Widget child;

  /// Same as [HeaderTile.trailing].
  final Widget trailing;

  /// The widget which should open on tap in an expanding animated fashion.
  /// Required.
  final Widget openWidget;

  /// A [HeaderTile] with [icon], [child], and [trailing] which expands to
  /// [openWidget] animated with [OpenContainer] on tap.
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
