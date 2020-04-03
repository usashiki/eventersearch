import 'package:eventernote/pages/calendar_page.dart';
import 'package:eventernote/pages/search_page.dart';
import 'package:eventernote/pages/settings_page.dart';
import 'package:eventernote/services/vertical_search_delegate.dart';
import 'package:eventernote/widgets/animated_indexed_stack.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mdi/mdi.dart';

void main() =>
    initializeDateFormatting('ja_jp').then((_) => runApp(EventernoteApp()));

class EventernoteApp extends StatefulWidget {
  EventernoteApp({Key key}) : super(key: key);

  @override
  _EventernoteAppState createState() => _EventernoteAppState();
}

class _EventernoteAppState extends State<EventernoteApp> {
  final List<Widget> pages = [
    SearchPage(),
    CalendarPage(),
    SettingsPage(),
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
      title: 'イベンターノート',
      // theme: ThemeData.from(
      //   colorScheme: ColorScheme.light(
      //     primary: Colors.blue,
      //     primaryVariant: Colors.blueAccent,
      //     secondary: Colors.indigo[200], // calendar today, loading circles
      //     secondaryVariant: Colors.indigo[400], // calendar select
      //   ),
      // ),
      // darkTheme: ThemeData.from(
      //   colorScheme: ColorScheme.dark(
      //     secondary: Colors.blue,
      //     secondaryVariant: Colors.blue[700],
      //   ),
      // ),
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: _BouncingScrollPhysicsBehavior(),
          child: child,
        );
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        canvasColor: Colors.white,
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
                    icon: Icon(Mdi.cogOutline),
                    title: Text('設定'),
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
