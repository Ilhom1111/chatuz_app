import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import '../../../models/user_model.dart';

sealed class DBService {
  static final db = FirebaseDatabase.instance;

  /// user
  static Future<bool> storeUser(
      String email, String password, String username, String uid) async {
    try {
      final folder = db.ref(Folder.user).child(uid);

      final member = Member(
        uid: uid,
        username: username,
        email: email,
        password: password,
      );
      await folder.set(member.toJson());

      return true;
    } catch (e) {
      debugPrint("DB ERROR: $e");
      return false;
    }
  }
}

sealed class Folder {
  static const user = "User";
}
