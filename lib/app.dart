import 'package:easy_localization/easy_localization.dart';
import 'package:filebase_chat_app/provider/firebase_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'blocs/auth/auth_bloc.dart';
import 'screens/auth_pages/sign_in_page.dart';
import 'screens/home_page.dart';
import 'services/firebase/auth_service/auth_service.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => AuthBloc()),
      ],
      child: ChangeNotifierProvider(
        create: (_) => FirebaseProvider(),
        child: MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          title: 'ChatUz',
          theme: ThemeData(
            primarySwatch: Colors.grey,
            useMaterial3: false,
          ),
          home: StreamBuilder<User?>(
              initialData: null,
              stream: AuthService.auth.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.data != null &&
                    FirebaseAuth.instance.currentUser!.emailVerified) {
                  return const HomePage();
                } else {
                  return const SignInPage();
                }
              }),
        ),
      ),
    );
  }
}
