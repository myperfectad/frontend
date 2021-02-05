import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../layout.dart';

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
        // the following didn't work:
        // KeyboardVisibilityBuilder(
        //   builder: (context, isVisible) {
        //     double padding = MediaQuery.of(context).viewInsets.bottom;
        //     return SizedBox(height: isVisible ? padding : 0.0);
        //   },
        // ),
        // workaround:
        if (!isDisplayDesktop(context))
          SizedBox(height: 256.0),
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
