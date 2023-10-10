import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

Future<UserCredential> signInWithFacebookNative() async {
  // Trigger the sign-in flow
  final LoginResult loginResult = await FacebookAuth.instance.login();

  // Create a credential from the access token
  final OAuthCredential facebookAuthCredential =
      FacebookAuthProvider.credential(loginResult.accessToken!.token);

  // Once signed in, return the UserCredential
  return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
}

Future<UserCredential> signInWithFacebookWeb() async {
  // Create a new provider
  FacebookAuthProvider facebookProvider = FacebookAuthProvider();

  facebookProvider.addScope('email');
  facebookProvider.setCustomParameters({
    'display': 'popup',
  });

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithPopup(facebookProvider);

  // Or use signInWithRedirect
  // return await FirebaseAuth.instance.signInWithRedirect(facebookProvider);
}

loginWithFB() async {
  UserCredential userCredential;
  try {
    if (kIsWeb) {
      userCredential = await signInWithFacebookWeb();
    } else {
      userCredential = await signInWithFacebookNative();
    }
  } catch (e) {
    if (kDebugMode) {
      print("error in sign in with google $e");
    }
  }
}

updateUserProfilefromFB(User user) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = firestore.collection("users");
  users.doc(user.uid).set({
    'uid': user.uid,
    'name': user.displayName,
    'dateOfBirth': "",
    'gender': "",
    'mobile': user.phoneNumber,
    'email': user.email,
    'isEmailVerified': user.emailVerified,
  }).then((value) {
    print("User Added");
  }).catchError((error) => print("Failed to add user: $error"));
}

signOutFB() async {
  await FirebaseAuth.instance.signOut();
}
