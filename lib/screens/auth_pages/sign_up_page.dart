import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../constants/colors.dart';
import '../../services/firebase/notification_service.dart';
import '../../views/auth/build_btn.dart';
import '../../views/auth/email_text_field.dart';
import '../../views/auth/password_text_field.dart';
import '../../views/auth/user_name_text_field.dart';
import '../../views/loading.dart';
import 'sign_in_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var prePasswordController = TextEditingController();
  static final notifications = NotificationsService();

  Widget buildSignupBtn() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "Do you have an account?",
            style: TextStyle(
                color: Colors.white,
                fontSize: 9 * MediaQuery.devicePixelRatioOf(context),
                fontWeight: FontWeight.w500),
          ),
          TextSpan(
              text: ' Sign In',
              style: TextStyle(
                fontSize: 9 * MediaQuery.devicePixelRatioOf(context),
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const SignInPage()));
                }),
        ],
      ),
    );
  }

  void showMesseginDialog(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (context) {
        return AlertDialog(
          shadowColor: MyColors.ff424769.withOpacity(.15),
          backgroundColor: Color.fromARGB(255, 197, 202, 228),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "A link has been sent to the email you entered. Confirm the email by clicking on the link!",
                style: TextStyle(
                    fontSize: 7.5 * MediaQuery.devicePixelRatioOf(context),
                    color: MyColors.ff2D3250,
                    fontWeight: FontWeight.w500),
              ).tr(),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.ff2D3250),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Ok", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message).tr()));
          }

          if (state is SignUpSuccess) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const SignInPage()));
            FirebaseAuth.instance.currentUser!.sendEmailVerification();
            showMesseginDialog(context);
          }
        },
        builder: (context, state) => Stack(
          children: [
            Stack(
              children: [
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0x662D3250),
                        Color(0x992D3250),
                        Color(0xcc2D3250),
                        Color(0xff2D3250),
                      ],
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      height: MediaQuery.sizeOf(context).height,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Spacer(flex: 4),
                          Center(
                            child: FittedBox(
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                    fontSize: 16 *
                                        MediaQuery.devicePixelRatioOf(context),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          const Spacer(flex: 3),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: UserNameTextField(
                              controller: nameController,
                            ),
                          ),
                          const Spacer(flex: 1),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: EmailTextField(
                              controller: emailController,
                            ),
                          ),
                          const Spacer(flex: 1),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: PasswordTextField(
                              controller: passwordController,
                            ),
                          ),
                          const Spacer(flex: 1),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: PasswordTextField(
                              controller: prePasswordController,
                            ),
                          ),
                          const Spacer(flex: 5),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: BuildBtn(
                              text: 'Sign Up',
                              onTap: () async {
                                context.read<AuthBloc>().add(
                                      SignUpEvent(
                                        username: nameController.text.trim(),
                                        email: emailController.text.trim(),
                                        password:
                                            passwordController.text.trim(),
                                        prePassword:
                                            prePasswordController.text.trim(),
                                      ),
                                    );
                                await notifications.requestPermission();
                                await notifications.getToken();
                              },
                            ),
                          ),
                          const Spacer(flex: 2),
                          Center(
                              child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: FittedBox(child: buildSignupBtn()),
                          )),
                          const Spacer(flex: 1),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            /// #laoding...
            if (state is AuthLoading) const Loading()
          ],
        ),
      ),
    );
  }
}
