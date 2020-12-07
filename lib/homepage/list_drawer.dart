import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ListDrawer extends StatefulWidget {
  @override
  _ListDrawerState createState() => _ListDrawerState();
}

class _ListDrawerState extends State<ListDrawer> {
  @override
  Widget build(BuildContext context) {
    final drawer = Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Image.asset(
                'images/logo.png',
                height: 96.0,
                alignment: Alignment.centerLeft,
              ),
              const Divider(),
              // const SizedBox(height: 16.0),
              GenderCheckBoxes(),
              // const SizedBox(height: 16.0),
              AgeSlider(),
              const SizedBox(height: 16.0),
              MiniMap(),
            ],
          ),
        ),
      ),
    );

    return Theme(
      child: drawer,
      data: Theme.of(context).copyWith(
        // note: this is exactly the default drawer color
        // if the canvasColor was not overriden in main
        canvasColor: Colors.grey[850],
      ),
    );
  }
}

class GenderCheckBoxes extends StatefulWidget {
  @override
  _GenderCheckBoxesState createState() => _GenderCheckBoxesState();
}

class _GenderCheckBoxesState extends State<GenderCheckBoxes> {
  bool isMale = true;
  bool isFemale = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CheckboxListTile(
          title: Text('Male'),
          controlAffinity: ListTileControlAffinity.leading,
          secondary: FaIcon(FontAwesomeIcons.male, color: isMale ? Theme.of(context).accentColor : null),
          value: isMale,
          activeColor: Colors.cyan,
          onChanged: (value) {
            setState(() {
              isMale = value;
            });
          },
        ),
        CheckboxListTile(
          title: Text('Female'),
          controlAffinity: ListTileControlAffinity.leading,
          secondary: FaIcon(FontAwesomeIcons.female, color: isFemale ? Theme.of(context).accentColor : null),
          value: isFemale,
          activeColor: Colors.cyan,
          onChanged: (value) {
            setState(() {
              isFemale = value;
            });
          },
        ),
      ],
    );
  }
}

class AgeSlider extends StatefulWidget {
  @override
  _AgeSliderState createState() => _AgeSliderState();
}

class _AgeSliderState extends State<AgeSlider> {
  RangeValues _currentRangeValues = const RangeValues(40, 80);

  @override
  Widget build(BuildContext context) {
    return RangeSlider(
      values: _currentRangeValues,
      min: 0,
      max: 100,
      divisions: 100,
      labels: RangeLabels(
        '${_currentRangeValues.start.round().toString()} years old',
        '${_currentRangeValues.end.round().toString()} years old',
      ),
      onChanged: (RangeValues values) {
        setState(() {
          _currentRangeValues = values;
        });
      },
    );
  }
}

class MiniMap extends StatefulWidget {
  @override
  _MiniMapState createState() => _MiniMapState();
}

class _MiniMapState extends State<MiniMap> {
  static final LatLng _kLondonCoords = LatLng(51.5074, 0.1278);
  static final double _kZoom = 5.0;

  Completer<GoogleMapController> _controller = Completer();
  Marker _currentPosMarker;
  LatLng _currentPos = _kLondonCoords;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.0,
      child: GoogleMap(
        mapType: MapType.normal,
        scrollGesturesEnabled: false,
        rotateGesturesEnabled: false,
        tiltGesturesEnabled: false,
        // removes the zoom buttons
        zoomControlsEnabled: false,
        initialCameraPosition: CameraPosition(
          target: _currentPos,
          zoom: _kZoom,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          setState(() {
            _currentPosMarker = Marker(
              markerId: MarkerId(_currentPos.toString()),
              position: _currentPos,
            );
          });
        },
        onTap: (_) async {
          await showDialog(
              context: context,
              builder: (context) {
                return MapDialog(_currentPos, _onMapTapped);
              });
          setState(() {
            _currentPosMarker = Marker(
              markerId: MarkerId(_currentPos.toString()),
              position: _currentPos,
            );
          });
          _goToCurrentPos();
        },
        markers: _currentPosMarker != null ? {_currentPosMarker} : null,
      ),
    );
  }
  
  void _onMapTapped(LatLng newPos) {
    _currentPos = newPos;
  }

  Future<void> _goToCurrentPos() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: _currentPos,
        zoom: _kZoom,
      ),
    ));
  }
}

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
      content: Container(
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
              _currentPosMarker = Marker(
                markerId: MarkerId(widget.initialPos.toString()),
                position: widget.initialPos,
              );
            });
          },
          onTap: (tapPosition) {
            setState(() {
              _currentPosMarker = Marker(
                // has to be new every time for it to update
                markerId: MarkerId(tapPosition.toString()),
                position: tapPosition,
              );
            });
            widget.onMapTapped(tapPosition);
          },
          markers: _currentPosMarker != null ? {_currentPosMarker} : null,
        ),
      ),
    );
  }
}


class _ThumbShape extends RoundRangeSliderThumbShape {
  final _indicatorShape = const PaddleRangeSliderValueIndicatorShape();

  const _ThumbShape();

  // how to always show thumb value: https://github.com/flutter/flutter/issues/34704
  // edit: could not get it to work

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        Animation<double> activationAnimation,
        Animation<double> enableAnimation,
        bool isDiscrete = false,
        bool isEnabled = false,
        bool isOnTop,
        SliderThemeData sliderTheme,
        TextDirection textDirection,
        Thumb thumb,
        bool isPressed,
      }) {
    super.paint(
      context,
      center,
      activationAnimation: activationAnimation,
      enableAnimation: enableAnimation,
      isDiscrete: isDiscrete,
      isEnabled: isEnabled,
      isOnTop: isOnTop,
      sliderTheme: sliderTheme,
      textDirection: textDirection,
      thumb: thumb,
      isPressed: isPressed,
    );

    _indicatorShape.paint(
      context,
      center,
      activationAnimation: const AlwaysStoppedAnimation(1),
      enableAnimation: enableAnimation,
      isDiscrete: isDiscrete,
      isOnTop: isOnTop,
      labelPainter: null,
      parentBox: null,
      sliderTheme: sliderTheme,
      textDirection: textDirection,
      thumb: thumb,
      value: 30,
      textScaleFactor: 0.6,
      sizeWithOverflow: null,
    );
  }
}