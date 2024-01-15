import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 100,
              color: const Color(0xff2D3250),
            ),
            FittedBox(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 11 * MediaQuery.devicePixelRatioOf(context),
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff2D3250),
                ),
              ).tr(),
            ),
          ],
        ),
      );
}
