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

  @override
  void initState() {
    super.initState();
    _currentPos = provider.location;
    _currentRange = provider.range;
    _currentPosMarker = _buildMarker(provider.location);
    _currentRangeCircle = _buildCircle(_currentPos, _currentRange);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await showDialog(
            context: context,
            builder: (context) {
              return MapDialog(
                GM.LatLng(_currentPos.latitude, _currentPos.longitude),
                _currentRange,
                _onMapTapped,
                _onRangeChanged,
              );
            });
        setState(() {
          _currentPosMarker = _buildMarker(_currentPos);
          _currentRangeCircle = _buildCircle(_currentPos, _currentRange);
        });
        _mapController.move(_currentPos, _kZoom);
        provider.location = _currentPos;
        provider.range = _currentRange;
      },
      child: SizedBox(
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
            CircleLayerOptions(circles: [
              _currentRangeCircle,
            ]),
            MarkerLayerOptions(
              markers: [
                _currentPosMarker,
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onMapTapped(GM.LatLng newPos) {
    _currentPos = LatLng(newPos.latitude, newPos.longitude);
  }

  void _onRangeChanged(double range) {
    _currentRange = range;
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
      radius: radius,
      point: pos,
      useRadiusInMeter: true,
      color: Color.lerp(Colors.cyan, Colors.transparent, 0.5),
      // borderStrokeWidth: 2.0,
      // borderColor: Colors.cyan,
    );
  }
}
