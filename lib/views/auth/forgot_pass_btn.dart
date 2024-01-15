import 'package:flutter/material.dart';

import '../../screens/auth_pages/forgot_password_page.dart';

class ForgotPassBtn extends StatelessWidget {
  const ForgotPassBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ForgotPasswordPage(),
            ),
          ),
          child: const Text(
            'Forgot Password?',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ));
  }
}
