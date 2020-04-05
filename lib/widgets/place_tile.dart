import 'package:eventersearch/models/place.dart';
import 'package:eventersearch/pages/place_page.dart';
import 'package:flutter/material.dart';

class PlaceTile extends StatelessWidget {
  final Place place;

  const PlaceTile(this.place, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(place.name),
      subtitle: Text(place.prefectureStr),
      dense: true,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PlacePage(place)),
      ),
    );
  }
}
