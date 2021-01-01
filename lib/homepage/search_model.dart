import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:http/http.dart' as http;

import 'homepage.dart';

final LatLng kLondonCoords = LatLng(51.509865, -0.118092);

enum Category {
  learning, film, fun, gaming, shopping, random, utility, irl
}

extension CategoryExtension on Category {
  String get name {
    switch (this) {
      
      case Category.learning:
        return 'Learning';
        break;
      case Category.film:
        return 'Film';
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
      case Category.utility:
        return 'Utility';
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
      case Category.film:
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
      case Category.utility:
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
  int _ageMin = 18;
  int _ageMax = 60;
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
    List<dynamic> jsonArray = jsonDecode(body);
    return jsonArray.map<Ad>((json) {
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

  Ad({this.id, this.title, this.desc, this.link, this.imageUrl, this.createdAt});

  factory Ad.fromJson(Map<String, dynamic> json) {
    return Ad(
      id: json['_id'],
      title: json['title'],
      desc: json['description'],
      link: json['link'],
      imageUrl: json['img'],
      createdAt: json['createdAt'],
    );
  }
}