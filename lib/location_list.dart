import 'package:flutter/material.dart';
import 'models/location.dart';
import 'styles.dart';
import 'location_detail.dart';

class LocationList extends StatelessWidget {
  final List<Location> _locations;

  const LocationList(this._locations, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Locations', style: Styles.navBarTitle),
        centerTitle: false,
      ),
      body: ListView.builder(
          itemCount: _locations.length, itemBuilder: _listViewItemBuilder),
    );
  }

  Widget _listViewItemBuilder(BuildContext context, int index) {
    Location currentLocation = _locations[index];
    return ListTile(
        contentPadding: const EdgeInsets.all(10.0),
        leading: _itemThumbnail(currentLocation),
        title: _itemTitle(currentLocation),
        onTap: () => _navigateToLocationDetail(context, currentLocation));
  }

  Widget _itemThumbnail(Location location) {
    return Container(
        constraints: const BoxConstraints.tightFor(width: 100.0),
        child: Image.network(location.url, fit: BoxFit.fitWidth));
  }

  Widget _itemTitle(Location location) {
    return Text(location.name, style: Styles.textDefault);
  }

  void _navigateToLocationDetail(BuildContext context, Location location) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => LocationDetail(location)));
  }
}
