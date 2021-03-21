import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:latlong/latlong.dart';
import 'package:http/http.dart' as http;

import '../layout.dart';
import 'adaptive_appbar.dart';
import 'list_drawer.dart';
import 'minimap.dart';
import 'search_model.dart';

const double MIN_AD_WIDTH = 256;

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final isDesktop = isDisplayDesktop(context);
    final body = SafeArea(
      child: ScrollContent(isDesktop),
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

  @override
  void initState() {
    super.initState();
    if (!widget.isDesktop) {
      _openDrawerAsync();
    }
  }

  void _openDrawerAsync() async {
    await Future.delayed(const Duration(seconds: 1));
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Consumer<SearchModel>(builder: (subContext, searchModel, child) {
        return FutureBuilder(
          future: searchModel.futureAds,
          builder: (context, snapshot) {
            // debugPrint('Loading future data...');

            if (snapshot.hasData) {
              List<Ad> ads = snapshot.data;

              if (ads.isEmpty) {
                return Center(
                  child: Text('No ads found ☹️ try expanding filters?'),
                );
              }

              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  // adaptive count. Count is always 2 on mobile
                  crossAxisCount: widget.isDesktop ? (constraints.maxWidth ~/ MIN_AD_WIDTH) : 2,
                ),
                itemCount: ads.length,
                itemBuilder: (context, index) {
                  // TODO add EOF?
                  Ad ad = ads[index];
                  return GridNode(ad);
                },
              );

            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            // By default, show a loading spinner.
            return Center(child: SpinKitFadingFour(color: Theme.of(context).accentColor));
          },
        );
      });
    });
  }
}

class GridNode extends StatelessWidget {

  final Ad ad;

  const GridNode(this.ad, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: '${ad.link}'
          '${ad.tags != null ? '\n${_parseTags()}' : ''}',
      child: InkWell(
        onTap: _launchLink,
        onDoubleTap: () {
          _showDetails(context);
        },
        onLongPress: () {
          _showDetails(context);
        },
        child: ad.imageUrl != null
            ? FadeInImage.memoryNetwork(
          image: ad.imageUrl,
          placeholder: kTransparentImage,
          // crops to square
          fit: BoxFit.cover,
        )
            : Center(child: Text('Image not available')),
      ),
    );
  }

  void _launchLink() async {
    if (await canLaunch(ad.link) && Uri.parse(ad.link).isAbsolute) {
      launch(ad.link);
      http.get(Uri.https(getHost(), '/items/detail/' + ad.id));
    }
  }

  String _parseTags() {
    if (ad.tags == null) return 'none';
    String s;
    bool first = true;
    for (var tag in ad.tags) {
      if (first) {
        s = tag;
        first = false;
      } else {
        s += ', $tag';
      }
    }
    return s;
  }

  void _showDetails(BuildContext context) {
    TextStyle bodyStyle = Theme.of(context).textTheme.bodyText1;

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(ad.title, style: Theme.of(context).textTheme.headline4),
            // As noted in the AlertDialog documentation,
            // it's important to use a SingleChildScrollView if there's
            // any risk that the content will not fit.
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ad.desc, style: bodyStyle),
                  const SizedBox(height: 16.0),
                  Text('Platform: ${ad.platform}', style: bodyStyle),
                  Text('Category: ${ad.category}', style: bodyStyle),
                  Text('Tags: ${_parseTags()}', style: bodyStyle),
                  const SizedBox(height: 16.0),
                  RichText(
                    text: TextSpan(
                      text: '${ad.link}',
                      style: bodyStyle.copyWith(
                        color: Theme.of(context).accentColor,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = _launchLink,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  _GridMap(ad.location),
                ],
              ),
            ),
          );
        },
    );
  }
}

class _GridMap extends StatelessWidget {
  // TODO on click launches to google maps?

  final LatLng location;

  const _GridMap(this.location, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 185.4,
      // width MUST be specified here
      width: 300.0,
      child: FlutterMap(
        options: MapOptions(
          center: location,
          zoom: MiniMap.kZoom,
          interactive: false,
        ),
        layers: [
          TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayerOptions(
            markers: [
              Marker(
                point: location,
                builder: (context) => Transform.translate(
                  offset: const Offset(0.0, -16.0), // translate by half height
                  child: Image.asset(
                    'images/location-pin.png',
                    color: Colors.black87,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
