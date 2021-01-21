import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'search_model.dart';
import 'search_params.dart';

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
      length: 5,
      child: AppBar(
        automaticallyImplyLeading: !isDesktop,
        centerTitle: isDesktop,
        title: isDesktop
            ? Text('Find Your Perfect Ad',
                style: Theme.of(context).textTheme.headline3)
              // otherwise too far to menu button
            : Transform.translate(
                offset: const Offset(-24.0, 0.0),
                child: Row(
                  children: [
                    Image.asset(
                      'images/arrow-left.png',
                      scale: 1.5,
                    ),
                    const SizedBox(width: 8.0),
                    Text('Find Your Perfect Ad ', // note space at end
                        style: Theme.of(context).textTheme.headline4),
                  ],
                ),
              ),
        bottom: TabBar(
          // a better way would be to generate these programmatically from the SortBy enum,
          // but I'm too lazy to do that
          tabs: [
            Tab(
              icon: isDesktop ? null : Icon(Icons.whatshot),
              child: _tabContent('Trending', Icons.whatshot),
            ),
            Tab(
              icon: isDesktop ? null : Icon(Icons.new_releases),
              child: _tabContent('Latest', Icons.new_releases)
            ),
            Tab(
                icon: isDesktop ? null : Icon(Icons.leaderboard),
                child: _tabContent('Top', Icons.leaderboard)
            ),
            Tab(
              icon: isDesktop ? null : Icon(Icons.shuffle),
              child: _tabContent('Random', Icons.shuffle),
            ),
            Tab(
              icon: isDesktop ? null : Icon(Icons.near_me),
              child: _tabContent('Nearest', Icons.near_me),
            ),
          ],
          onTap: (index) {
            SearchModel sm = Provider.of<SearchModel>(context, listen: false);
            // for this to work, make sure the order of enums is the order the tabs appear in!
            sm.sortBy = SortBy.values[index];
          },
        ),
        // actions: [
        //   // advertiser console not available on mobile
        //   if (isDesktop)
        //     IconButton(
        //       icon: const Icon(Icons.login),
        //       tooltip: 'Advertiser Login',
        //       onPressed: () {},
        //     ),
        // ],
      ),
    );
  }

  Widget _tabContent(String text, IconData iconData) {
    return isDesktop ? Row (
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(iconData),
        const SizedBox(width: 8.0,),
        Text(text),
      ],
    ) : null;
  }
}
