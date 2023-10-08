import 'package:firebase_auth/firebase_auth.dart';

Future<bool> sendForgetPasswordEmail(email) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    return true;
  } catch (e) {
    return false;
  }
}
