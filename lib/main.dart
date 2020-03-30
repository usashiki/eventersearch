import 'package:community_material_icon/community_material_icon.dart';
import 'package:eventernote/pages/calendar_navigation_page.dart';
import 'package:eventernote/pages/search_navigation_page.dart';
import 'package:eventernote/services/vertical_search_delegate.dart';
import 'package:eventernote/widgets/animated_indexed_stack.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() =>
    initializeDateFormatting('ja_jp').then((_) => runApp(EventernoteApp()));

class EventernoteApp extends StatefulWidget {
  EventernoteApp({Key key}) : super(key: key);

  @override
  _EventernoteAppState createState() => _EventernoteAppState();
}

class _EventernoteAppState extends State<EventernoteApp> {
  final List<Widget> pages = [
    SearchNavigationPage(),
    CalendarNavigationPage(),
    Icon(Icons.warning),
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
                    icon: Icon(CommunityMaterialIcons.calendar),
                    title: Text('カレンダー'),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
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
