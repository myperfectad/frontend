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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Choose your location:', style: Theme.of(context).textTheme.headline4),
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
            ),
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
  }

  @deprecated
  Circle _styleCircle(Circle c) {
    return c.copyWith(
      strokeWidthParam: 0,
      // strokeColorParam: Color.lerp(Colors.cyan, Colors.transparent, 0.3),
      fillColorParam: Color.lerp(Colors.cyan, Colors.transparent, 0.5),
    );
  }
}