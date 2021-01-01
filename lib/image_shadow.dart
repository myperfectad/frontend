import 'package:flutter/material.dart';

class ImageShadow extends StatelessWidget {
  final Widget child;
  final Offset offset;
  final String path;
  final double scale;

  ImageShadow({
    @required this.child,
    @required this.path,
    this.offset, this.scale,
  }) : assert(child != null);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Transform.translate(
          offset: offset ?? const Offset(3, 3),
          child: Image.asset(
            path,
            color: Colors.black,
            scale: scale ?? 1,
          ),
        ),
        child,
      ],
    );
  }
}
