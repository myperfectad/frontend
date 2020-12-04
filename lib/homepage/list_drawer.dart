import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ListDrawer extends StatefulWidget {
  @override
  _ListDrawerState createState() => _ListDrawerState();
}

class _ListDrawerState extends State<ListDrawer> {
  @override
  Widget build(BuildContext context) {
    final drawer = Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Image.asset(
                'images/logo.png',
                height: 96.0,
                alignment: Alignment.centerLeft,
              ),
              const Divider(),
              GenderSwitch(),
            ],
          ),
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

class GenderSwitch extends StatefulWidget {
  @override
  _GenderSwitchState createState() => _GenderSwitchState();
}

class _GenderSwitchState extends State<GenderSwitch> {
  bool isMale = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FaIcon(FontAwesomeIcons.male, color: isMale ? null : Theme.of(context).accentColor),
        Switch(
          value: isMale,
          onChanged: (newValue) {
            setState(() {
              isMale = newValue;
            });
          },
        ),
        FaIcon(FontAwesomeIcons.female, color: isMale ? Theme.of(context).accentColor : null),
      ],
    );
  }
}
