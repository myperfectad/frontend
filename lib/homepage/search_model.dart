import 'dart:convert';

import 'package:flutter/foundation.dart' as F;
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:http/http.dart' as http;

import 'search_params.dart';

const HOST = 'api.myperfectad.com';
const DEV_HOST = 'fathomless-spire-13212.herokuapp.com';

String getHost() => F.kReleaseMode ? HOST : DEV_HOST;

class SearchModel extends ChangeNotifier {
  bool _showMale = true;
  bool _showFemale = true;
  int _ageMin = 0;
  int _ageMax = 100;
  int _range = 1000; // in km
  LatLng _location = kLondonCoords;
  final Set<Platform> _platforms = {};
  final Set<Category> _categories = {};
  SortBy _sortBy = SortBy.trending;
  final List<String> _tags = [];

  Future<List<Ad>> _futureAds;

  SearchModel() {
    _futureAds = _fetchAds();
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

  void addPlatform(Platform platform) {
    _platforms.add(platform);
    _reFetch();
  }

  void removePlatform(Platform platform) {
    _platforms.remove(platform);
    _reFetch();
  }

  bool hasPlatform(Platform platform) {
    return _platforms.contains(platform);
  }

  /// Gets the current range in kilometers.
  int get range => _range;

  set range(int value) {
    _range = value;
    _reFetch();
  }

  SortBy get sortBy => _sortBy;

  set sortBy(SortBy s) {
    _sortBy = s;
    _reFetch();
  }

  void addTag(String tag) {
    _tags.add(tag);
    _reFetch();
  }

  void removeTag(String tag) {
    _tags.remove(tag);
    _reFetch();
  }

  void clearTags() {
    _tags.clear();
    _reFetch();
  }
  
  Future<List<Ad>> get futureAds => _futureAds;

  Uri _composeQuery() {
    Uri u = Uri(
      scheme: 'https',
      host: getHost(),
      path: '/items' + _sortBy.getPathFromSort,
      queryParameters: {
        'male': _showMale.toString(),
        'female': _showFemale.toString(),
        'minAge': _ageMin.toString(),
        'maxAge': _ageMax.toString(),
        'platforms': [
          for (var c in _platforms) c.toString().split('.').last,
        ],
        'categories': [
          for (var c in _categories) c.toString().split('.').last,
        ],
        'longitude': _location.longitude.toString(),
        'latitude': _location.latitude.toString(),
        'radius': _range >= 1000 ? '-1' : _range.toString(),
        'tags': _tags,
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
    _futureAds = _fetchAds();
    notifyListeners();
  }
}

class Ad {
  final String id;
  final String title;
  final String desc;
  final String link;
  final String imageUrl;
  final String createdAt;
  final String platform;
  final String category;
  final LatLng location;
  final List<String> tags;

  Ad({this.id, this.title, this.desc, this.link, this.imageUrl, this.createdAt, this.category, this.location, this.tags, this.platform});

  factory Ad.fromJson(Map<String, dynamic> json) {
    return Ad(
      id: json['_id'],
      title: json['title'],
      desc: json['description'],
      link: json['linkUrl'],
      imageUrl: json['photoUrl'],
      createdAt: json['createdAt'],
      platform: json['platform'],
      category: json['category'],
      location: LatLng(json['location']['lat'], json['location']['long']),
      tags: json['tags'].map<String>((tag) => tag.toString()).toList(),
    );
  }
}