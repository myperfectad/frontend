import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Tags extends StatefulWidget {
  @override
  _TagsState createState() => _TagsState();
}

class _TagsState extends State<Tags> {
  final List<String> _tags = [
    'Food',
    'Tech',
    'Sport',
    'Fitness',
    'Health',
    'Gaming',
    'Business',
    'Startups',
    'Eating',
    'Drinking',
  ];

  String _selected = '';

  @override
  Widget build(BuildContext context) {
    // https://stackoverflow.com/questions/56211844/flutter-web-mouse-hover-change-cursor-to-pointer
    return Container(
      child: RichText(
        text: TextSpan(
          children: _tags.map<TextSpan>(
            (tag) {
              return TextSpan(
                text: '$tag ',
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontSize: 18.0,
                      color: _selected == tag
                          ? Theme.of(context).accentColor
                          : Theme.of(context).backgroundColor,
                    ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    setState(() {
                      _selected = tag;
                    });
                  },
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
