import 'package:community_material_icon/community_material_icon.dart';
import 'package:eventernote/models/place.dart';
import 'package:eventernote/pages/place_page.dart';
import 'package:flutter/material.dart';

class PlaceSuggestionTile extends StatelessWidget {
  final Place place;

  const PlaceSuggestionTile(this.place, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(CommunityMaterialIcons.stadium),
      title: Text(place.name),
      dense: true,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PlacePage(place)),
      ),
    );
  }
}
