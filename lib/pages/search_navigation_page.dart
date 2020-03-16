import 'package:flutter/material.dart';

class SearchNavigationPage extends StatefulWidget {
  @override
  _SearchNavigationPageState createState() => _SearchNavigationPageState();
}

class _SearchNavigationPageState extends State<SearchNavigationPage>
    with SingleTickerProviderStateMixin {
  final List<Widget> _tabs = [
    ActorSearchTab(),
    FillerTab(),
    FillerTab(),
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
        title: Text('条件検索'),
        bottom: TabBar(
          controller: _tabController,
          tabs: <Widget>[
            Tab(text: '声優/ｱｰﾃｨｽﾄ'),
            Tab(text: 'イベント'),
            Tab(text: '会場'),
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

class ActorSearchTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.short_text),
                    labelText: 'キーワード',
                    hintText: '声優・アーティスト名等',
                  ),
                ),
                SizedBox(height: 10),
                RaisedButton(
                  child: Text('検索'),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
        Divider(height: 28, thickness: 1),
        ListTile(
          leading: Icon(Icons.translate),
          title: Text('頭文字から探す'),
          dense: true,
        ),
      ],
    );
  }
}

class FillerTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('wip');
  }
}
