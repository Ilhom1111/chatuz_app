import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:filebase_chat_app/constants/colors.dart';
import 'package:filebase_chat_app/views/auth/email_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _controller = TextEditingController();

  void resetPassword(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: LoadingAnimationWidget.dotsTriangle(
          color: MyColors.ffF6B17A,
          size: 50,
        ),
      ),
    );
    try {
      if (_controller.text.trim() != "") {
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: _controller.text.trim(),
        );
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      log(e.toString());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }

      if (mounted) {
        Navigator.pop(context);
      }
    }
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.ff2D3250,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(flex: 1),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: FittedBox(
                  child: Text(
                    "An email will be sent to reset your password.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10 * MediaQuery.devicePixelRatioOf(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ).tr(),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
                child: EmailTextField(
              controller: _controller,
            )),
            const Spacer(flex: 2),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: Size(MediaQuery.sizeOf(context).width, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  )),
              onPressed: () {
                resetPassword(context);
              },
              child: Text(
                "Reset password",
                style: TextStyle(
                  color: MyColors.ff2D3250,
                  fontSize: 16,
                ),
              ).tr(),
            ),
            SizedBox(height: 35),
          ],
        ),
      ),
    );
  }
}
