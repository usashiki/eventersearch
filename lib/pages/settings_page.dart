import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          AboutListTile(
            icon: Icon(Icons.info_outline),
            applicationIcon: Icon(Icons.search, size: 56),
            applicationVersion: '0.0.0',
            applicationLegalese: '© 2020 fc',
            aboutBoxChildren: <Widget>[
              SizedBox(height: 24),
              Text('このアプリは株式会社イベンターノートとは一切関係ありません。'),
            ],
          ),
        ],
      ),
    );
  }
}
