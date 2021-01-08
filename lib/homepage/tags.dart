import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Tags extends StatefulWidget {
  @override
  _TagsState createState() => _TagsState();
}

class _TagsState extends State<Tags> {
  static const List<String> kTags = [
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

  Map<String, bool> _tags;

  @override
  void initState() {
    super.initState();
    // TODO change to network
    _tags = Map.fromIterable(
      kTags,
      key: (tag) => tag,
      value: (tag) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // https://stackoverflow.com/questions/56211844/flutter-web-mouse-hover-change-cursor-to-pointer
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8.0),
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter search term',
          ),
        ),
        const SizedBox(height: 8.0),
        _suggestions(),
      ],
    );
  }

  Widget _suggestions() {
    return Wrap(
      spacing: 4.0,
      runSpacing: 4.0,
      children: _tags.entries.map<Widget>(
        (entry) {
          return ChoiceChip(
            label: Text(entry.key),
            selected: entry.value,
            onSelected: (bool selected) {
              setState(() {
                _tags[entry.key] = selected;
              });
            },
            selectedColor: Theme.of(context).accentColor,
          );
        },
      ).toList(),
    );
  }
}
