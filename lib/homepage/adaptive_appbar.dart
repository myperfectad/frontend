import 'package:flutter/material.dart';

const appBarDesktopHeight = 105.0;
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
    return DefaultTabController(
      length: 4,
      child: AppBar(
        automaticallyImplyLeading: !isDesktop,
        centerTitle: isDesktop,
        title: Text('My Perfect Ad!',
            style: isDesktop
                ? Theme.of(context).textTheme.headline3
                : Theme.of(context).textTheme.headline4),
        bottom: TabBar(
          tabs: [
            Tab(
              icon: isDesktop ? null : Icon(Icons.leaderboard),
              child: _tabContent('Top', Icons.leaderboard)
            ),
            Tab(
              icon: isDesktop ? null : Icon(Icons.whatshot),
              child: _tabContent('Trending', Icons.whatshot),
            ),
            Tab(
              icon: isDesktop ? null : Icon(Icons.new_releases),
              child: _tabContent('Latest', Icons.new_releases)
            ),
            Tab(
              icon: isDesktop ? null : Icon(Icons.elderly),
              child: _tabContent('Oldest', Icons.elderly),
            ),
          ],
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
      ),
    );
  }

  Widget _tabContent(String text, IconData iconData) {
    return isDesktop ? Row (
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text),
        const SizedBox(width: 8.0,),
        Icon(iconData),
      ],
    ) : null;
  }
}
