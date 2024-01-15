import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class EmailTextField extends StatelessWidget {
  final TextEditingController controller;
  const EmailTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FittedBox(
          child: Text(
            'Email',
            style: TextStyle(
                fontSize: 8 * MediaQuery.devicePixelRatioOf(context),
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 2),
              )
            ],
          ),
          height: 50,
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            controller: controller,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: MyColors.ff2D3250,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(
                Icons.email,
                color: MyColors.ff2D3250,
              ),
              hintText: 'Email',
              hintStyle: TextStyle(
                color: MyColors.ff7077A1,
              ),
            ),
          ),
        )
      ],
    );
  }
}
