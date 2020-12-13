import 'package:flutter/material.dart';

import '../layout.dart';
import 'adaptive_appbar.dart';
import 'list_drawer.dart';

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
        child: GridView.count(
          crossAxisCount: 2,
          children: List.generate(7, (index) {
            return Image.network(
              'http://www.ll-mm.com/images/placeholders/portfolio${index + 1}.jpg',
              // crops to square
              fit: BoxFit.cover,
            );
          }),
        ),
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
