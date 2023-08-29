import 'dart:async';
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
  bool _loading = false;

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
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: Column(
          children: [
            renderProgressBar(context),
            Expanded(
              child: renderListView(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadData() async {
    if (mounted) {
      setState(() => _loading = true);
      Timer(const Duration(milliseconds: 3000), () async {
        final locations = await Location.fetchAll();
        setState(() {
          _locations = locations;
          _loading = false;
        });
      });
    }
  }

  Widget renderProgressBar(BuildContext context) {
    return _loading
        ? const LinearProgressIndicator(
            value: null,
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey))
        : Container();
  }

  Widget renderListView(BuildContext context) {
    return ListView.builder(
        itemCount: _locations.length, itemBuilder: _listViewItemBuilder);
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
