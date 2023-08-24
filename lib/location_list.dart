import 'package:flutter/material.dart';
import 'models/location.dart';
import 'styles.dart';
import 'location_detail.dart';

class LocationList extends StatefulWidget {
  const LocationList({super.key});

  @override
  createState() => _LocationListState();
}

class _LocationListState extends State<LocationList> {
  List<Location> _locations = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

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

  _loadData() async {
    final locations = await Location.fetchAll();

    if (mounted) {
      setState(() {
        _locations = locations;
      });
    }
  }

  Widget _listViewItemBuilder(BuildContext context, int index) {
    final Location currentLocation = _locations[index];
    return ListTile(
        contentPadding: const EdgeInsets.all(10.0),
        leading: _itemThumbnail(currentLocation),
        title: _itemTitle(currentLocation),
        onTap: () => _navigateToLocationDetail(context, currentLocation.id));
  }

  Widget _itemThumbnail(Location location) {
    Image? image;
    try {
      image = Image.network(location.url, fit: BoxFit.fitWidth);
    } catch (e) {
      print("could not load image ${location.url}");
    }
    return Container(
        constraints: const BoxConstraints.tightFor(width: 100.0), child: image);
  }

  Widget _itemTitle(Location location) {
    return Text(location.name, style: Styles.textDefault);
  }

  void _navigateToLocationDetail(BuildContext context, int locationID) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => LocationDetail(locationID)));
  }
}
