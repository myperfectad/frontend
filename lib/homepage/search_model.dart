import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';

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
  double _range = 50000; // in meters
  LatLng _location = kLondonCoords;
  final Set<Category> _categories = {};

  bool get showMale => _showMale;

  set showMale(bool value) {
    _showMale = value;
    notifyListeners();
  }

  bool get showFemale => _showFemale;

  set showFemale(bool value) {
    _showFemale = value;
    notifyListeners();
  }

  LatLng get location => _location;

  set location(LatLng value) {
    _location = value;
    notifyListeners();
  }

  int get ageMax => _ageMax;

  set ageMax(int value) {
    _ageMax = value;
    notifyListeners();
  }

  int get ageMin => _ageMin;

  set ageMin(int value) {
    _ageMin = value;
    notifyListeners();
  }
  
  void addCategory(Category category) {
    _categories.add(category);
    notifyListeners();
  }

  void removeCategory(Category category) {
    _categories.remove(category);
    notifyListeners();
  }

  bool hasCategory(Category category) {
    return _categories.contains(category);
  }

  double get range => _range;

  set range(double value) {
    _range = value;
    notifyListeners();
  }
}