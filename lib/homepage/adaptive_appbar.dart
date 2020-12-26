import 'package:flutter/material.dart';

const appBarDesktopHeight = 110.0;
const appBarMobileHeight = 100.0;

class AdaptiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AdaptiveAppBar({
    Key key,
    this.isDesktop = false,
  }) : super(key: key);

  final bool isDesktop;

  @override
  Size get preferredSize => isDesktop
      ? const Size.fromHeight(appBarDesktopHeight)
      : const Size.fromHeight(appBarMobileHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: !isDesktop,
      centerTitle: isDesktop,
      title: Text('My Perfect Ad!',
          style: isDesktop
              ? Theme.of(context).textTheme.headline3
              : Theme.of(context).textTheme.headline4),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(26),
        child: Container(
          alignment: AlignmentDirectional.centerStart,
          margin: isDesktop
              ? const EdgeInsetsDirectional.fromSTEB(24, 0, 0, 12)
              : const EdgeInsetsDirectional.fromSTEB(8.0, 0, 0, 4.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.share),
                tooltip: 'Share',
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.favorite),
                tooltip: 'Favorite',
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.search),
                tooltip: 'Search',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
      actions: [
        // advertiser console not available on mobile
        if (isDesktop)
          IconButton(
            icon: const Icon(Icons.login),
            tooltip: 'Advertiser Login',
            onPressed: () {},
          ),
      ],
    );
  }
}
