import 'package:eventernote/pages/actor_ranking_page.dart';
import 'package:eventernote/pages/event_calendar_page.dart';
import 'package:eventernote/pages/place_map_page.dart';
import 'package:eventernote/services/vertical_search_delegate.dart';
import 'package:eventernote/widgets/fade_indexed_navigation.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() =>
    initializeDateFormatting('ja_jp').then((_) => runApp(EventernoteApp()));

class EventernoteApp extends StatelessWidget {
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
        builder: (context) => FadeIndexedNavigation(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () => showSearch(
                  context: context, delegate: VerticalSearchDelegate()),
            ),
          ],
          children: <NavigationPage>[
            EventCalendarPage(),
            ActorRankingPage(),
            PlaceMapPage(),
          ],
        ),
      ),
    );
  }
}
