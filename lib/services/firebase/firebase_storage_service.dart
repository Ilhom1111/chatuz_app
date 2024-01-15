import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class FirebaseStorageService {
  static final storage = FirebaseStorage.instance;
  static Future<String> uploadImage(Uint8List file, String storagePath) async =>
      await FirebaseStorage.instance
          .ref()
          .child(storagePath)
          .putData(file)
          .then((task) => task.ref.getDownloadURL());

  static Future<void> removeFile(String imagePath) async {
    var fileUrl = Uri.decodeFull(path.basename(imagePath))
        .replaceAll(RegExp(r'(\?alt).*'), '');
    final storeReference = storage.ref().child(fileUrl);
    await storeReference.delete();
  }

  static Future<String> uploadFile(File file) async {
    final image = storage.ref("profilImage").child(
        "image_${DateTime.now().toIso8601String()}${file.path.substring(file.path.lastIndexOf("."))}");
    final task = image.putFile(file);
    await task.whenComplete(() {});
    return image.getDownloadURL();
  }
}
