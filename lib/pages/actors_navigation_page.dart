import 'package:eventernote/pages/actors_ranking_tab.dart';
import 'package:eventernote/pages/new_actors_tab.dart';
import 'package:eventernote/services/vertical_search_delegate.dart';
import 'package:flutter/material.dart';

class ActorsNavigationPage extends StatefulWidget {
  @override
  _ActorsNavigationPageState createState() => _ActorsNavigationPageState();
}

class _ActorsNavigationPageState extends State<ActorsNavigationPage>
    with SingleTickerProviderStateMixin {
  final List<Widget> _tabs = [
    ActorsRankingTab(),
    NewActorsTab(),
  ];
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('声優/アーティスト'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            tooltip: '検索',
            onPressed: () => showSearch(
              context: context,
              delegate: VerticalSearchDelegate(),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: <Widget>[
            Tab(text: '人気'),
            Tab(text: '新着'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabs,
      ),
    );
  }
}
