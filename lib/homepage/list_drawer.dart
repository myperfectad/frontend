import 'package:flutter/material.dart';

class ListDrawer extends StatefulWidget {
  @override
  _ListDrawerState createState() => _ListDrawerState();
}

class _ListDrawerState extends State<ListDrawer> {
  static final numItems = 9;

  int selectedItem = 0;

  @override
  Widget build(BuildContext context) {
    final drawer = Drawer(
      child: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                'images/logo.png',
                height: 96.0,
                alignment: Alignment.centerLeft,
              ),
            ),
            // const Divider(),
            ...Iterable<int>.generate(numItems).toList().map((i) {
              return ListTile(
                enabled: true,
                selected: i == selectedItem,
                leading: const Icon(Icons.favorite),
                title: Text(
                  'Item ' + i.toString(),
                ),
                onTap: () {
                  setState(() {
                    selectedItem = i;
                  });
                },
              );
            }),
          ],
        ),
      ),
    );

    return Theme(
      child: drawer,
      data: Theme.of(context).copyWith(
        // note: this is exactly the default drawer color
        // if the canvasColor was not overriden in main
        canvasColor: Colors.grey[850],
      ),
    );
  }
}
