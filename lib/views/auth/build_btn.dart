import 'package:filebase_chat_app/constants/colors.dart';
import 'package:flutter/material.dart';

class BuildBtn extends StatelessWidget {
  final String text;
  final Function() onTap;
  const BuildBtn({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: FloatingActionButton(
          elevation: 5,
          onPressed: onTap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.white,
          child: Text(
            text,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: MyColors.ff2D3250),
          ),
        ));
  }
}
