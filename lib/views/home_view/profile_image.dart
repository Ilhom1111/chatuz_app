import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class ProfileImageHome extends StatelessWidget {
  final NetworkImage? image;
  final String? text;
  const ProfileImageHome({super.key, this.image, this.text});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: MyColors.ff7077A1.withOpacity(.80),
      backgroundImage: image,
      child: text != null
          ? Padding(
              padding: const EdgeInsets.all(9.0),
              child: FittedBox(
                child: Text(
                  text ?? "",
                  style: TextStyle(
                    fontSize: 11 * MediaQuery.devicePixelRatioOf(context),
                    color: MyColors.ff2D3250,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
