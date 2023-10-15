import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:github_sign_in/github_sign_in.dart';
import 'package:usermanagementapp/components/Config.dart';

Future<UserCredential> signInWithGitHubNative(BuildContext context) async {
  // Create a GitHubSignIn instance
  final GitHubSignIn gitHubSignIn = GitHubSignIn(
      clientId: ApiKeys.githubClientID,
      clientSecret: ApiKeys.githubClientSecretKey,
      redirectUrl: ApiKeys.githubRedirectUri);

  // Trigger the sign-in flow
  final result = await gitHubSignIn.signIn(context);

  // Create a credential from the access token
  final githubAuthCredential = GithubAuthProvider.credential(result.token!);

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(githubAuthCredential);
}

Future<UserCredential> signInWithGitHubWeb() async {
  // Create a new provider
  GithubAuthProvider githubProvider = GithubAuthProvider();

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithPopup(githubProvider);

  // Or use signInWithRedirect
  // return await FirebaseAuth.instance.signInWithRedirect(githubProvider);
}

loginWithGithub(BuildContext context) async {
  UserCredential? userCredential;
  try {
    if (kIsWeb) {
      userCredential = await signInWithGitHubWeb();
    } else {
      userCredential = await signInWithGitHubNative(context);
    }
  } catch (e) {
    if (kDebugMode) {
      print("Error on login with Github $e");
    }
  }
  return userCredential;
}

updateUserProfilefromGithub(User user) {
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
