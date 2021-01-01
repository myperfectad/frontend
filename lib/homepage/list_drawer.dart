import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as GM;
import 'package:myperfectad/homepage/search_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../state_with_provider.dart';
import 'map_dialog.dart';

class ListDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final drawer = Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Image.asset(
                'images/logo2.png',
                height: 96.0,
                alignment: Alignment.centerLeft,
              ),
              const Divider(),
              // const SizedBox(height: 16.0),
              ArrowDownTo(text: 'Choose yo\' self', child: GenderCheckBoxes()),
              // const SizedBox(height: 16.0),
              ArrowDownTo(text: 'Age', child: AgeSlider(), spacing: 36.0,),
              // const SizedBox(height: 16.0),
              ArrowDownTo(text: 'Location', child: MiniMap(), spacing: 36.0,),
              const SizedBox(height: 16.0),
              Text('What type?', style: Theme.of(context).textTheme.headline4),
              CategoriesPicker(),
              const SizedBox(height: 16.0),
              Text('What do you love?', style: Theme.of(context).textTheme.headline4),
              const Divider(),
              const SizedBox(height: 16.0),
              Footer(),
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

class ArrowDownTo extends StatelessWidget {
  final String text;
  final Widget child;
  final double spacing;

  const ArrowDownTo({Key key, @required this.text, @required this.child, this.spacing = 32.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: spacing),
          child: child,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: Theme.of(context).textTheme.headline4,
            ),
            const SizedBox(width: 16.0),
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Image.asset(
                'images/arrow-top.png',
                scale: 1.2,
                // color: Theme.of(context).accentColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class GenderCheckBoxes extends StatefulWidget {
  @override
  _GenderCheckBoxesState createState() => _GenderCheckBoxesState();
}

class _GenderCheckBoxesState extends StateWithProvider<GenderCheckBoxes, SearchModel> {
  bool isMale;
  bool isFemale;

  @override
  void initState() {
    super.initState();
    isMale = provider.showMale;
    isFemale = provider.showFemale;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CheckboxListTile(
          // title: Text('Male'),
          controlAffinity: ListTileControlAffinity.leading,
          title: FaIcon(FontAwesomeIcons.male, color: isMale ? Theme.of(context).accentColor : null),
          value: isMale,
          activeColor: Colors.cyan,
          onChanged: (value) {
            setState(() {
              isMale = value;
            });
            provider.showMale = value;
          },
        ),
        CheckboxListTile(
          // title: Text('Female'),
          controlAffinity: ListTileControlAffinity.leading,
          title: FaIcon(FontAwesomeIcons.female, color: isFemale ? Theme.of(context).accentColor : null),
          value: isFemale,
          activeColor: Colors.cyan,
          onChanged: (value) {
            setState(() {
              isFemale = value;
            });
            provider.showFemale = value;
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

class _AgeSliderState extends StateWithProvider<AgeSlider, SearchModel> {
  RangeValues _currentRangeValues;

  @override
  void initState() {
    super.initState();
    _currentRangeValues = RangeValues(provider.ageMin as double, provider.ageMax as double);
  }

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
      onChangeEnd: (RangeValues values) {
        provider.ageMin = values.start.round();
        provider.ageMax = values.end.round();
      },
    );
  }
}

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
            CircleLayerOptions(
                circles: [
                  _currentRangeCircle,
                ]
            ),
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

class CategoriesPicker extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CategoryButton(Category.learning),
            CategoryButton(Category.film),
            CategoryButton(Category.fun),
            CategoryButton(Category.gaming),
          ],
        ),
        const SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CategoryButton(Category.shopping),
            CategoryButton(Category.random),
            CategoryButton(Category.utility),
            CategoryButton(Category.irl),
          ],
        ),
      ],
    );
  }
}

class CategoryButton extends StatefulWidget {
  CategoryButton(this.category, {Key key}) : super(key: key);

  final Category category;

  @override
  _CategoryButtonState createState() => _CategoryButtonState();
}

class _CategoryButtonState extends StateWithProvider<CategoryButton, SearchModel> {
  bool isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = provider.hasCategory(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.category.name,
      child: InkWell(
        child: Image.asset(
          widget.category.iconPath,
          color: isSelected ? Theme.of(context).accentColor : Theme.of(context).backgroundColor,
        ),
        onTap: () {
          setState(() {
            isSelected = !isSelected;
          });
          if (isSelected) {
            provider.addCategory(widget.category);
          } else {
            provider.removeCategory(widget.category);
          }
        },
      ),
    );
  }
}

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: '© 2020 My Perfect Ad. Icons by ',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            TextSpan(
              text: 'Freepik',
              style: TextStyle(
                color: Theme.of(context).accentColor,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  launch('https://www.flaticon.com/authors/freepik');
                }
            )
          ],
        ),
      ),
    );
  }
}


@deprecated
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