// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyATiwkoW58-Jdn0LTqLi3tuDzTY96nqNjU',
    appId: '1:479914255164:web:2446d87c8b9118fe23f439',
    messagingSenderId: '479914255164',
    projectId: 'chatuzapp',
    authDomain: 'chatuzapp.firebaseapp.com',
    databaseURL: 'https://chatuzapp-default-rtdb.firebaseio.com',
    storageBucket: 'chatuzapp.appspot.com',
    measurementId: 'G-NB8J402CQ7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD0TEezv53v3JOA4BbXp5t3I-3HHie8fR8',
    appId: '1:479914255164:android:6ec9e2223e5161d823f439',
    messagingSenderId: '479914255164',
    projectId: 'chatuzapp',
    databaseURL: 'https://chatuzapp-default-rtdb.firebaseio.com',
    storageBucket: 'chatuzapp.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAOApjwh21GcnwCtHY0KI7maiM-LGDK6h8',
    appId: '1:479914255164:ios:c9d02718929407a823f439',
    messagingSenderId: '479914255164',
    projectId: 'chatuzapp',
    databaseURL: 'https://chatuzapp-default-rtdb.firebaseio.com',
    storageBucket: 'chatuzapp.appspot.com',
    iosBundleId: 'com.example.filebaseChatApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAOApjwh21GcnwCtHY0KI7maiM-LGDK6h8',
    appId: '1:479914255164:ios:dbfd365f3510c3f423f439',
    messagingSenderId: '479914255164',
    projectId: 'chatuzapp',
    databaseURL: 'https://chatuzapp-default-rtdb.firebaseio.com',
    storageBucket: 'chatuzapp.appspot.com',
    iosBundleId: 'com.example.filebaseChatApp.RunnerTests',
  );
}
