import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as GM;

import '../state_with_provider.dart';
import 'search_model.dart';
import 'map_dialog.dart';

class MiniMap extends StatefulWidget {
  @override
  _MiniMapState createState() => _MiniMapState();
}

class _MiniMapState extends StateWithProvider<MiniMap, SearchModel> {
  static final double _kZoom = 5.0;

  final MapController _mapController = MapController();

  Marker _currentPosMarker;
  CircleMarker _currentRangeCircle;

  LatLng _currentPos;
  double _currentRange;
  int _currentRangeKm;

  @override
  void initState() {
    super.initState();
    _currentPos = provider.location;
    _currentRange = provider.range;
    _currentRangeKm = (_currentRange / 1000).round();
    _currentPosMarker = _buildMarker(provider.location);
    _currentRangeCircle = _buildCircle(_currentPos, _currentRange);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () async {
            await showDialog(
                context: context,
                builder: (context) {
                  return MapDialog(
                    GM.LatLng(_currentPos.latitude, _currentPos.longitude),
                    _onMapTapped,
                  );
                });
            setState(() {
              _currentPosMarker = _buildMarker(_currentPos);
              _currentRangeCircle = _buildCircle(_currentPos, _currentRange);
            });
            _mapController.move(_currentPos, _kZoom);
            provider.location = _currentPos;
          },
          child: _map(),
        ),
        Row(
          children: [
            _rangeSlider(),
            Text(_currentRangeKm >= 100 ? 'Worldwide' : '${_currentRangeKm.toString()} km'),
          ],
        ),
      ],
    );
  }

  Widget _map() {
    return SizedBox(
      height: 200.0,
      child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: _currentPos,
          zoom: _kZoom,
          interactive: false,
        ),
        layers: [
          TileLayerOptions(
              urlTemplate:
              "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c']),
          // circle comes BEFORE marker
          CircleLayerOptions(
            circles: [_currentRangeCircle],
          ),
          MarkerLayerOptions(
            markers: [_currentPosMarker],
          ),
        ],
      ),
    );
  }

  Widget _rangeSlider() {
    return Slider(
      // clamp just in case
      value: _currentRangeKm.clamp(1, 100),
      min: 1,
      max: 100,
      divisions: 99,
      onChanged: (double value) {
        setState(() {
          _currentRangeKm = value.round();
          _currentRange = value * 1000;
          _currentRangeCircle = _buildCircle(_currentPos, _currentRange);
        });
      },
      onChangeEnd: (double value) {
        provider.range = value * 1000;
      },
    );
  }

  void _onMapTapped(GM.LatLng newPos) {
    _currentPos = LatLng(newPos.latitude, newPos.longitude);
  }

  Marker _buildMarker(LatLng pos) {
    return Marker(
      width: 32.0,
      height: 32.0,
      point: pos,
      builder: (context) => Image.asset('images/circular-target.png'),
    );
  }

  CircleMarker _buildCircle(LatLng pos, double radius) {
    return CircleMarker(
      radius: _currentRangeKm >= 100 ? 1000000.0 : radius,
      point: pos,
      useRadiusInMeter: true,
      color: Color.lerp(Colors.cyan, Colors.transparent, 0.5),
      // borderStrokeWidth: 2.0,
      // borderColor: Colors.cyan,
    );
  }
}
