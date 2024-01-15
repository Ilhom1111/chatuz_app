import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class Category extends StatelessWidget {
  final String text;
  final bool tf;
  final Function() onTap;
  final IconData icon;
  const Category(
      {super.key,
      required this.text,
      this.tf = false,
      required this.onTap,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          color: MyColors.ff2D3250,
        ),
        title: Text(
          text,
          style: TextStyle(
            color: MyColors.ff2D3250,
            fontSize: 8 * MediaQuery.devicePixelRatioOf(context),
            fontWeight: FontWeight.w500,
          ),
        ).tr(),
        trailing: tf
            ? const Icon(
                Icons.arrow_forward_ios_rounded,
                color: MyColors.ff7077A1,
              )
            : null);
  }
}
