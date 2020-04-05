import 'package:flutter/material.dart';

class DetailsHeaderTitle extends StatelessWidget {
  final String text;

  /// The title text for the header of a details page (one of
  /// [ActorDetailsPage], [EventDetailsPage]. [PlaceDetailsPage]).
  const DetailsHeaderTitle(this.text, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Text(text, style: Theme.of(context).textTheme.headline6),
    );
  }
}
