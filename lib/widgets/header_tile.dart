import 'package:flutter/material.dart';

/// Essentially a reimplementation of ListTile
class HeaderTile extends StatelessWidget {
  final IconData icon;
  final Widget child;
  final VoidCallback onTap, onLongPress;
  final bool omitBottomPadding;
  final Widget trailing;

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
    EdgeInsetsGeometry padding = EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 8,
    );
    if (omitBottomPadding) {
      padding = padding.subtract(EdgeInsets.only(bottom: 8));
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
              SizedBox(width: 16),
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
