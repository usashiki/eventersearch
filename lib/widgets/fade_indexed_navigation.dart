import 'package:flutter/material.dart';

// TODO: unused

/// Mixin for pages in FadeIndexedNavigation
mixin NavigationPage on Widget {
  String get title;
  String get navTitle;
  IconData get icon;

  BottomNavigationBarItem get navBarItem =>
      BottomNavigationBarItem(icon: Icon(icon), title: Text(navTitle));
}

/// App scaffold for bottom navigation with fade through between children backed
/// by an IndexedStack (so page state is saved on page change).
/// adapted from https://github.com/flutter/flutter/issues/48217#issuecomment-582535377
class FadeIndexedNavigation extends StatefulWidget {
  final List<Widget> actions; // actions for appbar
  final int index; // starting index
  final List<NavigationPage> children;

  FadeIndexedNavigation({
    Key key,
    this.actions, // TODO: move to NavigationPage?
    this.index: 0,
    @required this.children,
  })  : assert(children.isNotEmpty),
        super(key: key);

  @override
  _FadeIndexedNavigationState createState() => _FadeIndexedNavigationState();
}

class _FadeIndexedNavigationState extends State<FadeIndexedNavigation>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  int _index;
  List<String> _titles;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      ),
    );

    _titles = [for (NavigationPage p in widget.children) p.title];
    _index = widget.index;
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: widget.actions,
        title: Text(_titles[_index]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        items: [for (NavigationPage p in widget.children) p.navBarItem],
        onTap: (selectedIndex) {
          if (selectedIndex != _index) {
            _controller.reverse().then((_) {
              setState(() => _index = selectedIndex);
              _controller.forward();
            });
          }
        },
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
      body: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Opacity(
            opacity: _controller.value,
            child: Transform.scale(
              scale: 1.015 - (_controller.value * 0.015),
              child: child,
            ),
          );
        },
        child: IndexedStack(
          index: _index,
          children: widget.children,
        ),
      ),
    );
  }
}
