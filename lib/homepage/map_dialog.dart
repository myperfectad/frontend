import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapDialog extends StatefulWidget {
  MapDialog(this.initialPos, this.onMapTapped, {Key key}) : super(key: key);

  final LatLng initialPos;
  final void Function(LatLng) onMapTapped;

  @override
  _MapDialogState createState() => _MapDialogState();
}

class _MapDialogState extends State<MapDialog> {
  Marker _currentPosMarker;
  Circle _currentRangeCircle;
  double _currentRangeKm = 20;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 600.0,
            height: 400.0,
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                  target: widget.initialPos,
                  zoom: 10.0,
              ),
              onMapCreated: (_) {
                setState(() {
                  _setPosition(widget.initialPos);
                });
              },
              onTap: (tapPosition) {
                setState(() {
                  _setPosition(tapPosition);
                });
                widget.onMapTapped(tapPosition);
              },
              markers: _currentPosMarker != null ? {_currentPosMarker} : null,
              circles: _currentRangeCircle != null ? {_currentRangeCircle} : null,
            ),
          ),
          const SizedBox(height: 16.0),
          Slider(
            value: _currentRangeKm,
            min: 1,
            max: 100,
            divisions: 99,
            label: '${_currentRangeKm.round().toString()} km',
            onChanged: (double value) {
              setState(() {
                _currentRangeKm = value;
                _currentRangeCircle = _styleCircle(Circle(
                  circleId: CircleId('0'),
                  // keep current position
                  center: _currentPosMarker.position,
                  radius: _currentRangeKm * 1000,
                ));
              });
            },
          ),
        ],
      ),
    );
  }

  void _setPosition(LatLng position) {
    _currentPosMarker = Marker(
      // has to be new every time for it to update
      markerId: MarkerId(position.toString()),
      position: position,
    );
    _currentRangeCircle = _styleCircle(Circle(
      // does NOT need to be new every time. Weird
      circleId: CircleId('0'),
      center: position,
      radius: _currentRangeKm * 1000,
    ));
  }

  Circle _styleCircle(Circle c) {
    return c.copyWith(
      strokeWidthParam: 2,
      strokeColorParam: Color.lerp(Colors.cyan, Colors.transparent, 0.3),
      fillColorParam: Color.lerp(Colors.cyan, Colors.transparent, 0.8),
    );
  }
}