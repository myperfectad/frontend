import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../layout.dart';
import 'adaptive_appbar.dart';
import 'list_drawer.dart';
import 'search_model.dart';

const double MIN_AD_WIDTH = 256;
const String ENDPOINT = 'https://fathomless-spire-13212.herokuapp.com/ads';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final isDesktop = isDisplayDesktop(context);
    final body = SafeArea(
      child: Padding(
        padding: isDesktop
            ? const EdgeInsets.symmetric(horizontal: 72, vertical: 48)
            : const EdgeInsets.all(0),
            // : const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: ScrollContent(isDesktop),
      ),
    );

    if (isDesktop) {
      return Row(
        children: [
          ListDrawer(),
          // const VerticalDivider(width: 1),
          Expanded(
            child: Scaffold(
              appBar: const AdaptiveAppBar(
                isDesktop: true,
              ),
              body: body,
            ),
          ),
        ],
      );
    } else {
      return Scaffold(
        appBar: const AdaptiveAppBar(),
        body: body,
        drawer: ListDrawer(),
      );
    }
  }
}

class ScrollContent extends StatefulWidget {
  ScrollContent(this.isDesktop, {Key key}) : super(key: key);

  final bool isDesktop;

  @override
  _ScrollContentState createState() => _ScrollContentState();
}

class _ScrollContentState extends State<ScrollContent> {
  Future<List<Ad>> _futureAds;

  @override
  void initState() {
    super.initState();
    _futureAds = _fetchAds();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Consumer<SearchModel>(
        builder: (subContext, cart, child) {
          // _fetchAds();
          return child;
        },
        child: FutureBuilder(
          future: _futureAds,
          builder: (context, snapshot) {

            if (snapshot.hasData) {
              // TODO should probably change to builder
              return GridView.count(
                // adaptive count. Count is always 2 on mobile
                  crossAxisCount: widget.isDesktop ? (constraints.maxWidth ~/ MIN_AD_WIDTH) : 2,
                  children: snapshot.data.map<GridNode>((Ad ad) {
                    return GridNode(
                      title: ad.title,
                      desc: ad.desc,
                      link: ad.link,
                      imageUrl: ad.imageUrl,
                    );
                  }).toList(),
              );
            }

            // By default, show a loading spinner.
            return CircularProgressIndicator();
          },
        ),
      );
    });
  }

  // TODO send filters
  Future<List<Ad>> _fetchAds() async {
    final response = await http.get(ENDPOINT);
    debugPrint(response.statusCode.toString());

    if (response.statusCode == 200) {
      return _parseAds(response.body);
    }
    else {
      throw Exception('Failed to load');
    }
  }

  List<Ad> _parseAds(String body) {
    List<dynamic> jsonArray = jsonDecode(body);
    return jsonArray.map<Ad>((json) {
      // debugPrint(json.toString());
      return Ad.fromJson(json);
    }).toList();
  }
}

class Ad {
  final String id;
  final String title;
  final String desc;
  final String link;
  final String imageUrl;
  final String createdAt;

  Ad({this.id, this.title, this.desc, this.link, this.imageUrl, this.createdAt});

  factory Ad.fromJson(Map<String, dynamic> json) {
    return Ad(
      id: json['_id'],
      title: json['title'],
      desc: json['description'],
      link: json['link'],
      imageUrl: json['img'],
      createdAt: json['createdAt'],
    );
  }
}

class GridNode extends StatelessWidget {
  final String title;
  final String desc;
  final String link;
  final String imageUrl;

  const GridNode({Key key, this.title, this.desc, this.link, this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: '$title: $desc',
      child: InkWell(
        onTap: () {
          launch(link);
        },
        child: imageUrl != null
            ? Image.network(
          imageUrl,
          // crops to square
          fit: BoxFit.cover,
        )
            : Center(child: Text('Image not available')),
      ),
    );
  }
}
