import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:twitter_login/twitter_login.dart';
import 'package:usermanagementapp/components/Config.dart';

Future<UserCredential> signInWithTwitterNative() async {
  // Create a TwitterLogin instance
  final twitterLogin = new TwitterLogin(
      apiKey: ApiKeys.twitterConsumerKey,
      apiSecretKey: ApiKeys.twitterConsumerSecret,
      redirectURI: ApiKeys.twitterRedirectURL);

  // Trigger the sign-in flow
  final authResult = await twitterLogin.login();

  // Create a credential from the access token
  final twitterAuthCredential = TwitterAuthProvider.credential(
    accessToken: authResult.authToken!,
    secret: authResult.authTokenSecret!,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance
      .signInWithCredential(twitterAuthCredential);
}

Future<UserCredential> signInWithTwitterWeb() async {
  // Create a new provider
  TwitterAuthProvider twitterProvider = TwitterAuthProvider();

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithPopup(twitterProvider);

  // Or use signInWithRedirect
  // return await FirebaseAuth.instance.signInWithRedirect(twitterProvider);
}

loginWithTwitter() async {
  try {
    UserCredential userCredential;
    if (kIsWeb) {
      userCredential = await signInWithTwitterWeb();
    } else {
      userCredential = await signInWithTwitterNative();
    }
  } catch (e) {
    if (kDebugMode) {
      print("error in sign in with Twitter $e");
    }
  }
}

signOutTwitter() async {
  await FirebaseAuth.instance.signOut();
}

updateUserProfilefromTwitter(User user) {
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
