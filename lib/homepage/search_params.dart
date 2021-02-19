import 'package:latlong/latlong.dart';

final LatLng kLondonCoords = LatLng(51.509865, -0.118092);

enum Category {
  youtube, entertainment, etsy, shopify, indiedevs, random, tool, irl
}

extension CategoryExtension on Category {
  String get name {
    switch (this) {

      case Category.youtube:
        return 'Youtube';
        break;
      case Category.entertainment:
        return 'Entertainment';
        break;
      case Category.etsy:
        return 'Etsy';
        break;
      case Category.shopify:
        return 'Shopify';
        break;
      case Category.indiedevs:
        return 'Indie Devs';
        break;
      case Category.random:
        return 'Random';
        break;
      case Category.tool:
        return 'Tool';
        break;
      case Category.irl:
        return 'IRL';
        break;
      default:
        return null;
    }
  }

  String get iconPath {
    switch (this) {
      case Category.youtube:
        return 'images/youtube.png';
        break;
      case Category.entertainment:
        return 'images/cinema.png';
        break;
      case Category.etsy:
        return 'images/etsy.png';
        break;
      case Category.shopify:
        return 'images/shopify.png';
        break;
      case Category.indiedevs:
        return 'images/webdev.png';
        break;
      case Category.random:
        return 'images/random.png';
        break;
      case Category.tool:
        return 'images/toolbox.png';
        break;
      case Category.irl:
        return 'images/town.png';
        break;
      default:
        return null;
    }
  }

  @deprecated // probably needlessly expensive
  static Category fromString(String s) {
    s = s.toLowerCase();

    for (Category c in Category.values) {
      if (c.name.toLowerCase() == s)
        return c;
    }

    return null;
  }
}

enum SortBy {
  trending, latest, top, random, nearest
}

extension SortByExtension on SortBy {

  String get getPathFromSort {
    switch (this) {
      case SortBy.trending:
        return '/trending';
      case SortBy.latest:
        return '/latest';
      case SortBy.top:
        return '/top';
      case SortBy.random:
        return '/random';
      case SortBy.nearest:
      default:
        return '/nearest';
    }
  }
}