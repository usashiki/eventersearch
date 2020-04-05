import 'package:eventersearch/pages/calendar_page.dart';
import 'package:eventersearch/pages/favorites_page.dart';
import 'package:eventersearch/pages/search_page.dart';
import 'package:eventersearch/services/favorites_state.dart';
import 'package:eventersearch/services/vertical_search_delegate.dart';
import 'package:eventersearch/widgets/animated_indexed_stack.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mdi/mdi.dart';
import 'package:provider/provider.dart';

void main() =>
    initializeDateFormatting('ja_jp').then((_) => runApp(ChangeNotifierProvider(
        create: (_) => FavoritesState(), child: const EventersearchApp())));

class EventersearchApp extends StatefulWidget {
  const EventersearchApp({Key key}) : super(key: key);

  @override
  _EventersearchAppState createState() => _EventersearchAppState();
}

class _EventersearchAppState extends State<EventersearchApp> {
  final _pages = const <Widget>[
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
      title: 'イベンターサーチ',
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
              child: AnimatedIndexedStack(index: _index, children: _pages),
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
                    title: const Text('検索'),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Mdi.calendarOutline),
                    title: const Text('カレンダー'),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.favorite_border),
                    title: const Text('お気に入り'),
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
