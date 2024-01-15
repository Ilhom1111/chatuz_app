import 'package:filebase_chat_app/constants/colors.dart';
import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  const PasswordTextField({super.key, required this.controller});

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool tf = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        FittedBox(
          child: Text(
            'Password',
            style: TextStyle(
              fontSize: 8 * MediaQuery.devicePixelRatioOf(context),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
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
            controller: widget.controller,
            obscureText: tf,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: MyColors.ff2D3250,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(top: 14),
              prefixIcon: const Icon(
                Icons.lock,
                color: MyColors.ff2D3250,
              ),
              suffixIcon: IconButton(
                  onPressed: () {
                    tf = !tf;
                    setState(() {});
                  },
                  icon: Icon(
                    tf == false
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: MyColors.ff2D3250,
                  )),
              hintText: 'Password',
              hintStyle: const TextStyle(
                color: MyColors.ff7077A1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
