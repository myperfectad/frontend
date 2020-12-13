import 'package:flutter/material.dart';

import '../layout.dart';
import 'adaptive_appbar.dart';
import 'list_drawer.dart';

class HomePage extends StatelessWidget {
  static const double MIN_AD_WIDTH = 256;

  @override
  Widget build(BuildContext context) {
    final isDesktop = isDisplayDesktop(context);
    final body = SafeArea(
      child: Padding(
        padding: isDesktop
            ? const EdgeInsets.symmetric(horizontal: 72, vertical: 48)
            : const EdgeInsets.all(0),
            // : const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: LayoutBuilder(builder: (context, constraints) {
          // TODO should probably change to builder
          return GridView.count(
            // adaptive count. Count is always 2 on mobile
            crossAxisCount: isDesktop ? (constraints.maxWidth ~/ MIN_AD_WIDTH) : 2,
            children: List.generate(30, (index) {
              return Image.network(
                'https://picsum.photos/id/${index + 9}/512',
                // crops to square
                fit: BoxFit.cover,
              );
            }),
          );
        }),
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
