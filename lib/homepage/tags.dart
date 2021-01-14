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
    // https://stackoverflow.com/questions/51652897/how-to-hide-soft-input-keyboard-on-flutter-after-clicking-outside-textfield-anyw
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
        _suggestions(context),
      ],
    );
  }

  Widget _suggestions(BuildContext context) {
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
              FocusScope.of(context).unfocus();
            },
            selectedColor: Theme.of(context).accentColor,
          );
        },
      ).toList(),
    );
  }
}
