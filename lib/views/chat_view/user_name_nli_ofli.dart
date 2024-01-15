import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class UserNameOnliOfli extends StatelessWidget {
  final String name;
  final bool isOnline;
  const UserNameOnliOfli(
      {super.key, required this.name, required this.isOnline});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
                text: '$name\n',
                style: TextStyle(
                  color: MyColors.ff2D3250,
                  fontSize: 8 * MediaQuery.devicePixelRatioOf(context),
                  fontWeight: FontWeight.w600,
                )),
            TextSpan(
                text: isOnline ? "Online".tr() : "Offline".tr(),
                style: TextStyle(
                  color: isOnline ? MyColors.ffF6B17A : MyColors.ff7077A1,
                  fontSize: 6.5 * MediaQuery.devicePixelRatioOf(context),
                  fontWeight: FontWeight.w400,
                )),
          ],
        ),
      ),
    );
  }
}
