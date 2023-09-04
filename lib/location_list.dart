import 'dart:async';
import 'package:flutter/material.dart';
import 'components/location_tile.dart';
import 'models/location.dart';
import 'location_detail.dart';
import 'styles.dart';

const listItemHeight = 245.0;

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
    return GestureDetector(
      onTap: () => _navigateToLocationDetail(context, currentLocation.id),
      child: SizedBox(
          height: listItemHeight,
          child: Stack(children: [
            _tileImage(currentLocation.url, MediaQuery.of(context).size.width,
                listItemHeight),
            _tileFooter(currentLocation)
          ])),
    );
  }

  void _navigateToLocationDetail(BuildContext context, int locationID) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => LocationDetail(locationID)));
  }

  Widget _tileImage(String url, double width, double height) {
    Image? image;
    try {
      image = Image.network(url, fit: BoxFit.cover);
    } catch (e) {
      print("could not load image $url");
    }
    return Container(constraints: const BoxConstraints.expand(), child: image);
  }

  Widget _tileFooter(Location location) {
    final info = LocationTile(location: location, darkTheme: true);
    final overlay = Container(
        padding: const EdgeInsets.symmetric(
            vertical: 5.0, horizontal: Styles.horizontalPaddingDefault),
        decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
        child: info);
    return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [overlay]);
  }
}
