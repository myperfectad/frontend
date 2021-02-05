import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myperfectad/homepage/search_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../image_shadow.dart';
import '../state_with_provider.dart';
import 'minimap.dart';
import 'search_params.dart';
import 'tags.dart';

class ListDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final drawer = Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView(
            children: [
              const SizedBox(height: 16.0),
              Image.asset(
                'images/logo2.png',
                height: 96.0,
                alignment: Alignment.centerLeft,
              ),
              const SizedBox(height: 16.0),
              // const SizedBox(height: 16.0),
              ArrowDownTo(text: 'Choose yo\' self', child: GenderCheckBoxes()),
              AgeSlider(),
              const SizedBox(height: 16.0),
              Text('Location', style: Theme.of(context).textTheme.headline4),
              MiniMap(),
              // const SizedBox(height: 16.0),
              Text('What do you feel like?', style: Theme.of(context).textTheme.headline4),
              CategoriesPicker(),
              const SizedBox(height: 16.0),
              Text('What do you love?', style: Theme.of(context).textTheme.headline4),
              Tags(),
              const SizedBox(height: 32.0),
              Footer(),
              const SizedBox(height: 16.0),
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

  const ArrowDownTo({Key key, @required this.text, @required this.child, this.spacing = 48.0})
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
            const SizedBox(width: 48.0),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // this is really not clean. But hey, it works, and nothing really depends on this, so yeah
        InkWell(
          child: ImageShadow(
            path: 'images/boy.png',
            scale: 1.7,
            child: Image.asset(
              'images/boy.png',
              scale: 1.7,
              color: isMale ? Theme.of(context).accentColor : Theme.of(context).backgroundColor,
            ),
          ),
          onTap: () {
            setState(() {
              isMale = !isMale;
              provider.showMale = isMale;
            });
          },
        ),
        InkWell(
          child: ImageShadow(
            path: 'images/girl.png',
            scale: 1.7,
            child: Image.asset(
              'images/girl.png',
              scale: 1.7,
              color: isFemale ? Theme.of(context).accentColor : Theme.of(context).backgroundColor,
            ),
          ),
          onTap: () {
            setState(() {
              isFemale = !isFemale;
              provider.showFemale = isFemale;
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

class _AgeSliderState extends StateWithProvider<AgeSlider, SearchModel> {
  RangeValues _currentRangeValues;

  @override
  void initState() {
    super.initState();
    _currentRangeValues = RangeValues(provider.ageMin as double, provider.ageMax as double);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RangeSlider(
          values: _currentRangeValues,
          min: 0,
          max: 100,
          divisions: 100,
          onChanged: (RangeValues values) {
            setState(() {
              _currentRangeValues = values;
            });
          },
          onChangeEnd: (RangeValues values) {
            provider.setAgeRange(values.start.round(), values.end.round());
          },
        ),
        Row(
          children: [
            const SizedBox(width: 8.0,),
            Text('${_currentRangeValues.start.round().toString()} yrs'),
            Spacer(),
            Text('${_currentRangeValues.end.round().toString()} yrs'),
          ],
        ),
      ],
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
            CategoryButton(Category.entertainment),
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
            CategoryButton(Category.tool),
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
          FocusScope.of(context).unfocus();
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
              text: '© 2021 My Perfect Ad.',
              style: TextStyle(
                color: Theme.of(context).accentColor,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'My Perfect Ad',
                      applicationVersion: '1.0.0-alpha1',
                      applicationIcon: Image.asset('images/logo2.png', height: 64.0, width: 64.0),
                      children: [
                        FlatButton.icon(
                            onPressed: () {
                              launch('https://instagram.com/myperfectadapp');
                            },
                            icon: FaIcon(FontAwesomeIcons.instagram),
                            label: Text('myperfectadapp'),
                        ),
                        FlatButton.icon(
                            onPressed: () {
                              launch('https://twitter.com/myperfectad');
                            },
                            icon: FaIcon(FontAwesomeIcons.twitter),
                            label: Text('myperfectad'),
                        ),
                        FlatButton.icon(
                            onPressed: () {
                              launch('mailto:rob@myperfectad.com');
                            },
                            icon: FaIcon(FontAwesomeIcons.envelope),
                            label: Text('rob@myperfectad.com'),
                        ),
                      ],
                    );
                  }),
            TextSpan(
              text: ' Icons by ',
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