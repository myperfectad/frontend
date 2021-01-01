import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:http/http.dart' as http;

import 'homepage.dart';

final LatLng kLondonCoords = LatLng(51.509865, -0.118092);

enum Category {
  learning, entertainment, fun, gaming, shopping, random, tool, irl
}

extension CategoryExtension on Category {
  String get name {
    switch (this) {
      
      case Category.learning:
        return 'Learning';
        break;
      case Category.entertainment:
        return 'Entertainment';
        break;
      case Category.fun:
        return 'Fun';
        break;
      case Category.gaming:
        return 'Gaming';
        break;
      case Category.shopping:
        return 'Shopping';
        break;
      case Category.random:
        return 'Random';
        break;
      case Category.tool:
        return 'Tool';
        break;
      case Category.irl:
        return 'IRL';
        break;
      default:
        return null;
    }
  }
  
  String get iconPath {
    switch (this) {
      case Category.learning:
        return 'images/book.png';
        break;
      case Category.entertainment:
        return 'images/cinema.png';
        break;
      case Category.fun:
        return 'images/confetti.png';
        break;
      case Category.gaming:
        return 'images/game-controller.png';
        break;
      case Category.shopping:
        return 'images/online-shopping.png';
        break;
      case Category.random:
        return 'images/random.png';
        break;
      case Category.tool:
        return 'images/toolbox.png';
        break;
      case Category.irl:
        return 'images/town.png';
        break;
      default:
        return null;
    }
  }
}

class SearchModel extends ChangeNotifier {
  bool _showMale = true;
  bool _showFemale = true;
  int _ageMin = 0;
  int _ageMax = 100;
  double _range = 80000; // in meters
  LatLng _location = kLondonCoords;
  final Set<Category> _categories = {};
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

  set ageMax(int value) {
    _ageMax = value;
    _reFetch();
  }

  int get ageMin => _ageMin;

  set ageMin(int value) {
    _ageMin = value;
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

  // TODO send filters
  Future<List<Ad>> _fetchAds() async {
    final response = await http.get(ENDPOINT);
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
  final String tags;

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