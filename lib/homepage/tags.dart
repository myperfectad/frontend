import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:myperfectad/state_with_provider.dart';

import '../layout.dart';
import 'search_model.dart';

class Tags extends StatefulWidget {
  @override
  _TagsState createState() => _TagsState();
}

class _TagsState extends StateWithProvider<Tags, SearchModel> {

  final Map<String, bool> _tags = {};

  @override
  void initState() {
    super.initState();
    _tags.addEntries(
      provider.getTags().map<MapEntry<String, bool>>(
            (tag) => MapEntry(tag, true),
          ),
    );
    _fetchSuggestions(null);
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
          onChanged: (str) {
            // when you type a search term, clear the tags that aren't selected
            setState(() {
              _clearUnselectedTags();
            });
            _fetchSuggestions(str);
          },
        ),
        const SizedBox(height: 8.0),
        _buildSuggestions(context),
        // the following didn't work:
        // KeyboardVisibilityBuilder(
        //   builder: (context, isVisible) {
        //     double padding = MediaQuery.of(context).viewInsets.bottom;
        //     return SizedBox(height: isVisible ? padding : 0.0);
        //   },
        // ),
        // workaround:
        if (!isDisplayDesktop(context))
          SizedBox(height: 300.0),
      ],
    );
  }

  Widget _buildSuggestions(BuildContext context) {
    return Wrap(
      spacing: 4.0,
      runSpacing: 4.0,
      children: _tags.entries.map<Widget>(
        (entry) => ChoiceChip(
          label: Text(entry.key),
          selected: entry.value,
          onSelected: (bool selected) {
            setState(() {
              _tags[entry.key] = selected;
            });
            if (selected) {
              provider.addTag(entry.key);
            } else {
              provider.removeTag(entry.key);
            }
            FocusScope.of(context).unfocus();
          },
          selectedColor: Theme.of(context).buttonColor,
        )
      ).toList(),
    );
  }

  void _fetchSuggestions(String str) async {
    final response = await http.get(Uri.https(
      getHost(),
      '/tags',
      {'query': str},
    ));

    if (response.statusCode == 200) {
      List<dynamic> tagsList = jsonDecode(response.body)['tags'];

      for (var tag in tagsList) {
        String s = tag.toString();
        // don't add if it's already selected, otherwise duplicate
        if (!_tags.containsKey(s))
          _tags[s] = false;
      }

      // don't forget
      setState(() {});
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  void _clearUnselectedTags() {
    _tags.removeWhere((key, value) => value == false);
  }
}
