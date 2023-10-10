import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

final FirebaseStorage storage = FirebaseStorage.instance;
final ImagePicker _picker = ImagePicker();

Future<String?> uploadImageAndGetLink(inputsource) async {
  final XFile? pickedImage = await _picker.pickImage(
    source: inputsource == 'camera' ? ImageSource.camera : ImageSource.gallery,
  );

  if (pickedImage == null) {
    return null;
  }
  try {
    final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final Reference reference = storage.ref().child('images/$fileName');
    await reference.putFile(File(pickedImage.path));
    final String downloadURL = await reference.getDownloadURL();
    return downloadURL;
  } catch (e) {
    if (kDebugMode) {
      print('Error uploading image: $e');
      return null;
    }
  }
  return null;
}
