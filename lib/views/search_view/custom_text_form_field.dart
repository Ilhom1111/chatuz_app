import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {super.key, required this.controller, this.hintText, this.onChanged});

  final TextEditingController controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 54,
        width: double.infinity,
        child: TextFormField(
          controller: controller,
          style: const TextStyle(
            color: Color(0xff2D3250),
            fontWeight: FontWeight.w500,
          ),
          obscureText: false,
          onChanged: onChanged,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsetsDirectional.symmetric(horizontal: 15),
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Color(0xff7077A1),
            ),
            suffixIcon: const Icon(
              Icons.search,
              color: Color(0xff2D3250),
            ),
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xff2D3250)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xff2D3250)),
            ),
          ),
        ),
      );
}
