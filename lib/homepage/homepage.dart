import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:transparent_image/transparent_image.dart';

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
                  return GridNode(
                    title: ad.title,
                    desc: ad.desc,
                    link: ad.link,
                    imageUrl: ad.imageUrl,
                    tags: ad.tags,
                  );
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
  final String title;
  final String desc;
  final String link;
  final String imageUrl;
  final List<String> tags;

  const GridNode({Key key, this.title, this.desc, this.link, this.imageUrl, this.tags}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: '$link'
          '${tags != null ? '\n${_parseTags()}' : ''}',
      child: InkWell(
        onTap: () {
          launch(link);
        },
        child: imageUrl != null
            ? FadeInImage.memoryNetwork(
          image: imageUrl,
          placeholder: kTransparentImage,
          // crops to square
          fit: BoxFit.cover,
        )
            : Center(child: Text('Image not available')),
      ),
    );
  }

  String _parseTags() {
    String s;
    bool first = true;
    for (var tag in tags) {
      if (first) {
        s = tag;
        first = false;
      } else {
        s += ', $tag';
      }
    }
    return s;
  }
}
