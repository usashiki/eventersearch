import 'package:eventersearch/models/place.dart';
import 'package:eventersearch/pages/place_details_page.dart';
import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';

class PlaceSuggestionTile extends StatelessWidget {
  final Place place;

  /// A minimal [ListTile] listing a [place]'s name with a keading icon.
  const PlaceSuggestionTile(this.place, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Mdi.mapMarkerOutline),
      title: Text(place.name),
      dense: true,
      onTap: () => Navigator.push<Widget>(
        context,
        MaterialPageRoute(builder: (context) => PlaceDetailsPage(place)),
      ),
    );
  }
}
