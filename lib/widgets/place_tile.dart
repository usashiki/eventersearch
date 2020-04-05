import 'package:eventersearch/models/place.dart';
import 'package:eventersearch/pages/place_details_page.dart';
import 'package:flutter/material.dart';

class PlaceTile extends StatelessWidget {
  final Place place;

  /// A [ListTile] listing a [place]'s name and prefecture.
  /// When tapped opens a [PlaceDetailsPage] for [place].
  const PlaceTile(this.place, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(place.name),
      subtitle: Text(place.prefectureStr),
      dense: true,
      onTap: () => Navigator.push<Widget>(
        context,
        MaterialPageRoute(builder: (context) => PlaceDetailsPage(place)),
      ),
    );
  }
}
