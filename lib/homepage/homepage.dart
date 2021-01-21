import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:latlong/latlong.dart';

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

class ScrollContent extends StatelessWidget {
  ScrollContent(this.isDesktop, {Key key}) : super(key: key);

  final bool isDesktop;

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
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  // adaptive count. Count is always 2 on mobile
                  crossAxisCount: isDesktop ? (constraints.maxWidth ~/ MIN_AD_WIDTH) : 2,
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
    if (await canLaunch(ad.link) && Uri.parse(ad.link).isAbsolute)
      launch(ad.link);
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
                width: 32.0,
                height: 32.0,
                builder: (context) => Image.asset('images/circular-target.png'),
              )
            ],
          ),
        ],
      ),
    );
  }
}
