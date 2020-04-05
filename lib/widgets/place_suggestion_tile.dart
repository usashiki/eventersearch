import 'package:eventersearch/models/place.dart';
import 'package:eventersearch/pages/place_page.dart';
import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';

class PlaceSuggestionTile extends StatelessWidget {
  final Place place;

  const PlaceSuggestionTile(this.place, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Mdi.mapMarkerOutline),
      title: Text(place.name),
      dense: true,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PlacePage(place)),
      ),
    );
  }
}
