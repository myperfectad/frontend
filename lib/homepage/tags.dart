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

  Future<Map<String, bool>> _futureTagSugs;

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
            setState(() {
              _futureTagSugs = _fetchSuggestions(str);
            });
            provider.clearTags();
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
          SizedBox(height: 256.0),
      ],
    );
  }

  Widget _buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: _futureTagSugs,
      builder: (context, AsyncSnapshot<Map<String, bool>> snapshot) {
        
        if (snapshot.hasData) {
          return Wrap(
            spacing: 4.0,
            runSpacing: 4.0,
            children: snapshot.data.entries.map<Widget>(
              (entry) => ChoiceChip(
                  label: Text(entry.key),
                  selected: entry.value,
                  onSelected: (bool selected) {
                    setState(() {
                      snapshot.data[entry.key] = selected;
                    });
                    if (selected) {
                      provider.addTag(entry.key);
                    } else {
                      provider.removeTag(entry.key);
                    }
                    FocusScope.of(context).unfocus();
                  },
                  selectedColor: Theme.of(context).accentColor,
                )
            ).toList(),
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        
        // don't display anything
        return Row();
      },
    );
  }

  Future<Map<String, bool>> _fetchSuggestions(String str) async {
    final response = await http.get(Uri.https(
      getHost(),
      '/tags',
      {'query': str},
    ));

    if (response.statusCode == 200) {
      List<dynamic> tagsList = jsonDecode(response.body)['tags'];
      return Map.fromIterable(
        tagsList,
        key: (tag) => tag.toString(),
        value: (tag) => false,
      );
    } else {
      throw Exception('Failed to fetch tag suggestions');
    }
  }
}
