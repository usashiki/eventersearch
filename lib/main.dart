import 'package:eventernote/pages/calendar_page.dart';
import 'package:eventernote/pages/favorites_page.dart';
import 'package:eventernote/pages/search_page.dart';
import 'package:eventernote/services/favorites_state.dart';
import 'package:eventernote/services/vertical_search_delegate.dart';
import 'package:eventernote/widgets/animated_indexed_stack.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mdi/mdi.dart';
import 'package:provider/provider.dart';

void main() =>
    initializeDateFormatting('ja_jp').then((_) => runApp(ChangeNotifierProvider(
        create: (_) => FavoritesState(), child: EventernoteApp())));

class EventernoteApp extends StatefulWidget {
  EventernoteApp({Key key}) : super(key: key);

  @override
  _EventernoteAppState createState() => _EventernoteAppState();
}

class _EventernoteAppState extends State<EventernoteApp> {
  final List<Widget> pages = [
    SearchPage(),
    CalendarPage(),
    FavoritesPage(),
  ];
  int _index;

  @override
  void initState() {
    super.initState();
    _index = 0;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // debugShowCheckedModeBanner: false,
      title: 'イベンターノート',
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: _BouncingScrollPhysicsBehavior(),
          child: child,
        );
      },
      theme: ThemeData(
        primaryColor: Colors.blue,
        // canvasColor: Colors.white,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        accentColor: Colors.blue,
      ),
      home: Builder(
        // builder for Navigator (for showSearch)
        builder: (context) {
          return Scaffold(
            body: SafeArea(
              child: AnimatedIndexedStack(index: _index, children: pages),
            ),
            bottomNavigationBar: SafeArea(
              child: BottomNavigationBar(
                currentIndex: _index,
                onTap: (selectedIndex) {
                  if (_index != selectedIndex) {
                    setState(() => _index = selectedIndex);
                  } else if (selectedIndex == 0) {
                    // open search/keyboard if already on search page
                    showSearch(
                      context: context,
                      delegate: VerticalSearchDelegate(),
                    );
                  }
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search),
                    title: Text('検索'),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Mdi.calendarOutline),
                    title: Text('カレンダー'),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.favorite_border),
                    title: Text('お気に入り'),
                  ),
                ],
                // backgroundColor: Theme.of(context).primaryColor,
                // selectedItemColor: Colors.white,
                // unselectedItemColor: Colors.grey,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _BouncingScrollPhysicsBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    // sets BouncingScrollPhysics for all Scrollables
    return const BouncingScrollPhysics();
  }

  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    // removes overglow (appears in TabView)
    return child;
  }
}
