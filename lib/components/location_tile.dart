import 'package:flutter/material.dart';
import '../models/location.dart';
import '../styles.dart';

const locationTileHeight = 100.0;

class LocationTile extends StatelessWidget {
  final Location location;
  final bool darkTheme;

  const LocationTile(
      {super.key, required this.location, this.darkTheme = false});

  @override
  Widget build(BuildContext context) {
    final title = location.name.toUpperCase();
    final subTitle = location.userItinerarySummary.toUpperCase();
    final caption = location.tourPackageName.toUpperCase();

    return Container(
        padding: const EdgeInsets.all(0.0),
        height: locationTileHeight,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: darkTheme
                      ? Styles.locationTileTitleDark
                      : Styles.locationTileTitleLight),
              Text(subTitle, style: Styles.locationTileSubTitle),
              Text(caption, style: Styles.locationTileCaption)
            ]));
  }
}
