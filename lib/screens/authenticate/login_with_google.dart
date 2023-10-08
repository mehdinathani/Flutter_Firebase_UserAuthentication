import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<UserCredential> signInWithGoogleNative() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

Future<UserCredential> signInWithGoogleWeb() async {
  // Create a new provider
  GoogleAuthProvider googleProvider = GoogleAuthProvider();

  googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
  googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithPopup(googleProvider);

  // Or use signInWithRedirect
  // return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
}

loginWithGoogle() async {
  try {
    UserCredential userCredential;
    if (kIsWeb) {
      userCredential = await signInWithGoogleWeb();
    } else {
      userCredential = await signInWithGoogleNative();
    }
  } catch (e) {
    if (kDebugMode) {
      print("error in sign in with google $e");
    }
  }
}

updateUserProfilefromGoogle(User user) {
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

// Sign out on the web using Firebase
Future<void> signOutWeb() async {
  await FirebaseAuth.instance.signOut();
}

// Sign out on native platforms using Google Sign-In plugin
Future<void> signOutNative() async {
  await GoogleSignIn().signOut();
}

Future<void> GoogleSignOut() async {
  try {
    if (kIsWeb) {
      await signOutWeb();
    } else {
      await signOutNative();
    }
    // Handle successful sign-out (e.g., navigate to a sign-in screen)
  } catch (e) {
    // Handle sign-out errors here
    if (kDebugMode) {
      print("Error signing out: $e");
    }
  }
}
