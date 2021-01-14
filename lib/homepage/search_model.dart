import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:http/http.dart' as http;

import 'homepage.dart';
import 'search_params.dart';

class SearchModel extends ChangeNotifier {
  bool _showMale = true;
  bool _showFemale = true;
  int _ageMin = 0;
  int _ageMax = 100;
  double _range = 300000; // in meters
  LatLng _location = kLondonCoords;
  final Set<Category> _categories = {};
  Future<List<Ad>> _futureAds;

  SearchModel() {
    // _futureAds = _fetchAds();
  }

  bool get showMale => _showMale;

  set showMale(bool value) {
    _showMale = value;
    _reFetch();
  }

  bool get showFemale => _showFemale;

  set showFemale(bool value) {
    _showFemale = value;
    _reFetch();
  }

  LatLng get location => _location;

  set location(LatLng value) {
    _location = value;
    _reFetch();
  }

  int get ageMax => _ageMax;
  int get ageMin => _ageMin;

  void setAgeRange(int min, int max) {
    _ageMin = min;
    _ageMax = max;
    _reFetch();
  }
  
  void addCategory(Category category) {
    _categories.add(category);
    _reFetch();
  }

  void removeCategory(Category category) {
    _categories.remove(category);
    _reFetch();
  }

  bool hasCategory(Category category) {
    return _categories.contains(category);
  }

  /// Gets the current range in meters.
  double get range => _range;

  set range(double value) {
    _range = value;
    _reFetch();
  }
  
  Future<List<Ad>> get futureAds => _futureAds;

  Uri _composeQuery() {
    Uri u = Uri.https(
      'fathomless-spire-13212.herokuapp.com',
      '/ads',
      {
        'male': _showMale.toString(),
        'female': _showFemale.toString(),
        'minAge': _ageMin.toString(),
        'maxAge': _ageMax.toString(),
        // TODO
        // for (var c in _categories)
        //   'categories' : c.name.toLowerCase(),
      },
    );
    debugPrint(u.toString());
    return u;
  }

  Future<List<Ad>> _fetchAds() async {
    final response = await http.get(_composeQuery());
    // debugPrint(response.statusCode.toString());

    if (response.statusCode == 200) {
      return _parseAds(response.body);
    }
    else {
      throw Exception('Failed to load');
    }
  }

  List<Ad> _parseAds(String body) {
    var json = jsonDecode(body);
    return json['ads'].map<Ad>((json) {
      // debugPrint(json.toString());
      return Ad.fromJson(json);
    }).toList();
  }

  void _reFetch() {
    // _futureAds = _fetchAds();
    // notifyListeners();
  }
}

class Ad {
  final String id;
  final String title;
  final String desc;
  final String link;
  final String imageUrl;
  final String createdAt;
  final List<String> tags;

  Ad({this.id, this.title, this.desc, this.link, this.imageUrl, this.createdAt, this.tags});

  factory Ad.fromJson(Map<String, dynamic> json) {
    return Ad(
      id: json['_id'],
      title: json['title'],
      desc: json['description'],
      link: json['linkUrl'],
      imageUrl: json['photoUrl'],
      createdAt: json['createdAt'],
    );
  }
}