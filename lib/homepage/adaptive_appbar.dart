import 'package:flutter/material.dart';

const appBarDesktopHeight = 128.0;

class AdaptiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AdaptiveAppBar({
    Key key,
    this.isDesktop = false,
  }) : super(key: key);

  final bool isDesktop;

  @override
  Size get preferredSize => isDesktop
      ? const Size.fromHeight(appBarDesktopHeight)
      : const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: !isDesktop,
      title: isDesktop
          ? null
          : Text('Add sort by buttons here mobile'),
      bottom: isDesktop
          ? PreferredSize(
        preferredSize: const Size.fromHeight(26),
        child: Container(
          alignment: AlignmentDirectional.centerStart,
          margin: const EdgeInsetsDirectional.fromSTEB(72, 0, 0, 22),
          child: Text(
              'Add sort by buttons here'
          ),
        ),
      )
          : null,
      actions: [
        // TODO
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
    );
  }
}
