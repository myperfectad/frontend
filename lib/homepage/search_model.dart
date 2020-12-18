import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';

final LatLng kLondonCoords = LatLng(51.509865, -0.118092);

class SearchModel extends ChangeNotifier {
  bool _showMale = true;
  bool _showFemale = true;
  int _ageMin = 18;
  int _ageMax = 60;
  LatLng _location = kLondonCoords;

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
}