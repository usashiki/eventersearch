import 'package:flutter/material.dart';

class HeaderTile extends StatelessWidget {
  /// The leading icon displayed on the left-hand side of the tile. Required.
  final IconData icon;

  /// The widget contained in the tile. Required.
  final Widget child;

  /// Callback for when the tile is tapped.
  final VoidCallback onTap;

  /// Callback for when the tile is long pressed.
  final VoidCallback onLongPress;

  /// The trailing widget displayed on the right-hand side of the tile.
  final Widget trailing;

  /// Flag to omit the bottom 8px of padding. Used when nesting
  /// [HeaderTile]s.
  final bool omitBottomPadding;

  /// An informational tile for use in the header of a details page. Comes with
  /// a leading [icon], [child] widget, callbacks [onTap] and [onLongPress], and
  /// optionally a [trailing] widget.
  ///
  /// See also: [ExpandableHeaderTile], [LaunchableHeaderTile].
  ///
  /// Essentially a reimplementation of ListTile.
  const HeaderTile({
    @required this.icon,
    @required this.child,
    this.onTap,
    this.onLongPress,
    this.omitBottomPadding = false,
    this.trailing,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EdgeInsetsGeometry padding =
        const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
    if (omitBottomPadding) {
      padding = padding.subtract(const EdgeInsets.only(bottom: 8));
    }

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: padding,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: Icon(icon, color: Colors.grey),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: child,
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: trailing,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
