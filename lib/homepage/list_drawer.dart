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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'images/logo.png',
                height: 96.0,
                alignment: Alignment.centerLeft,
              ),
              // const Divider(),
              const SizedBox(height: 16.0),
              GenderSwitch(),
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

class GenderSwitch extends StatefulWidget {
  @override
  _GenderSwitchState createState() => _GenderSwitchState();
}

class _GenderSwitchState extends State<GenderSwitch> {
  bool isMale = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FaIcon(FontAwesomeIcons.male, color: isMale ? null : Theme.of(context).accentColor),
        Switch(
          value: isMale,
          onChanged: (newValue) {
            setState(() {
              isMale = newValue;
            });
          },
        ),
        FaIcon(FontAwesomeIcons.female, color: isMale ? Theme.of(context).accentColor : null),
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
        _currentRangeValues.start.round().toString(),
        _currentRangeValues.end.round().toString(),
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
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.0,
      child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
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