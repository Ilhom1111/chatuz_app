import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../firebase_firestore_service.dart';
import 'db_service.dart';

sealed class AuthService {
  static final auth = FirebaseAuth.instance;

  static Future<bool> signUp(
      String email, String password, String username) async {
    try {
      final credential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (credential.user != null) {
        await credential.user!.updateDisplayName(username);

        FirebaseFirestoreService.createUser(
          name: username,
          email: email,
          uid: credential.user!.uid,
        );

        await DBService.storeUser(
          email,
          password,
          username,
          credential.user!.uid,
        );
      }

      return credential.user != null;
    } catch (e) {
      debugPrint("SignUp ERROR: $e");
      return false;
    }
  }

  static Future<bool> signIn(String email, String password) async {
    try {
      final credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseFirestoreService.updateUserData({'lastActive': DateTime.now()},
          FirebaseAuth.instance.currentUser!.uid);
      return credential.user != null;
    } catch (e) {
      debugPrint("SignIn ERROR: $e");
      return false;
    }
  }

  static Future<bool> signOut() async {
    try {
      await auth.signOut();
      return true;
    } catch (e) {
      debugPrint("SignOut ERROR: $e");
      return false;
    }
  }

  static Future<bool> deleteAccount() async {
    try {
      if (auth.currentUser != null) {
        await auth.currentUser!.delete();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("DeleteAccount ERROR: $e");
      return false;
    }
  }

  static User get user => auth.currentUser!;
}
