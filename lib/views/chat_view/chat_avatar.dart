import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class ChatAvatar extends StatelessWidget {
  final String image;
  final String? name;
  const ChatAvatar({super.key, required this.image, this.name});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: MyColors.ff2D3250,
      backgroundImage: image != "no image" ? NetworkImage(image) : null,
      child: Text(
        name?[0] ?? '',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12 * MediaQuery.devicePixelRatioOf(context),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
