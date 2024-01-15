import 'dart:developer';

import 'package:flutter/material.dart';

class ZoomImage extends StatefulWidget {
  final String image;
  const ZoomImage({super.key, required this.image});

  @override
  State<ZoomImage> createState() => _ZoomImageState();
}

class _ZoomImageState extends State<ZoomImage> {
  double zoom = 1;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      onDoubleTap: () {
        log("$zoom");
        if (zoom == 4) {
          zoom = 1;
          setState(() {});
        } else {
          zoom++;
          setState(() {});
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Transform.scale(
            scale: zoom,
            child: Image.network(widget.image),
          ),
        ),
      ),
    );
  }
}
