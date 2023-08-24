import 'dart:async';
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;
import 'location_fact.dart';
import '../endpoint.dart';

part 'location.g.dart';

@JsonSerializable()
class Location {
  final int id;
  final String name;
  final String url;
  final List<LocationFact> facts;

  Location(
      {required this.id,
      required this.name,
      required this.url,
      required this.facts});

  Location.blank(): id = 0, name = '', url = '', facts = [];

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  // Usually would have pagination
  static Future<List<Location>> fetchAll() async {
    var uri = Endpoint.uri('/locations');

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw(response.body);
    }

    List<Location> list = [];
    for (var jsonItem in json.decode(response.body)) {
      jsonItem['facts'] = [];
      list.add(Location.fromJson(jsonItem));
    }

    return list;
  }

  static Future<Location> fetchByID(int id) async {
    var uri = Endpoint.uri('/locations/$id');

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw(response.body);
    }

    final Map<String, dynamic> itemMap = json.decode(response.body);

    return Location.fromJson(itemMap);
  }
}
