import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:usermanagementapp/screens/authenticate/login.dart';
import 'package:usermanagementapp/screens/authenticate/login_with_google.dart';

class HomePage extends StatefulWidget {
  final User? user;
  const HomePage({super.key, this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _updateDisplayName = TextEditingController();
  final _updateEmailAddress = TextEditingController();
  final _updatePhoneNumber = TextEditingController();
  final _updatePassword = TextEditingController();
  final _updateGender = TextEditingController();
  final _updateDOB = TextEditingController();
  final _updatePhotoURL = TextEditingController();

  bool isEmailVerified = false;

  String? userProfileName;
  String? userEmailID;
  String? userMobileNumber;
  String? photoURL;

  @override
  void initState() {
    super.initState();
    loadUserProfileDate();
  }

  getUserData() async {
    if (widget.user?.uid != null) {
      final userStoreData = await getDocumentData(widget.user!.uid);
      if (userStoreData != null) {
        setState(() {
          this.userStoreData = userStoreData; // Update the class-level variable
        });
        // Do something with the userStoreData
        print(userStoreData);
        print("Name: ${userStoreData['name']}");
      }
    }
  }

  var userStoreData = {};

  Future<bool?> checkEmailVerification() async {
    final emailVerified = await widget.user?.emailVerified;
    setState(() {
      isEmailVerified = emailVerified ?? false;
    });
  }

  loadUserProfileDate() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userProfileName = userStoreData['name']; //user.displayName;
        userEmailID = user.email;
        userMobileNumber = user.phoneNumber;
        photoURL = user.photoURL;
        checkEmailVerification();
        print(user);
      });
    }
  }

  updateDisplayNameFunction() async {
    await widget.user?.updateDisplayName(_updateDisplayName.text);
    setState(() {
      userProfileName = _updateDisplayName.text;
    });
    Navigator.of(context).pop();
  }

  void showSnackbar(String message) {
    final snackBar = SnackBar(
      duration: const Duration(seconds: 3),
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  sendVerificationRequest() async {
    await widget.user?.sendEmailVerification();
    var regEmail = userEmailID ?? "your Registered email address.";
    setState(() {
      String customSnackBarMSG =
          'A verification Email has been sent to ${regEmail} .';
      showSnackbar(customSnackBarMSG);
    });
    Navigator.of(context).pop();
  }

  updateEmailAddress() async {
    await widget.user?.updateEmail(_updateEmailAddress.text);
    setState(() {
      userEmailID = _updateEmailAddress.text;
    });
    Navigator.of(context).pop();
  }

  updateProfileImage() async {
    await widget.user?.updatePhotoURL(_updatePhotoURL.text);
    setState(() {
      photoURL = _updatePhotoURL.text;
    });
    Navigator.of(context).pop();
  }

  void displayAlertWithFun({
    required String headingText,
    required String hintText,
    required Function() onPressed,
    required TextEditingController fieldcontroller,
  }) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(headingText),
          content: TextField(
            controller: fieldcontroller,
            decoration: InputDecoration(
              hintText: hintText,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: onPressed,
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Future<String?> _showUpdateProfilePictureDialog() {
      return showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Update Profile Picture using"),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  final newPhotoURL = await uploadImageAndGetLink('camera');
                  Navigator.of(context).pop(newPhotoURL); // Close the dialog
                },
                child: Text("Camera"),
              ),
              TextButton(
                onPressed: () async {
                  final newPhotoURL = await uploadImageAndGetLink('gallery');
                  Navigator.of(context).pop(newPhotoURL); // Close the dialog
                },
                child: Text("Gallery"),
              ),
            ],
          );
        },
      );
    }

    getUserData();
    var customSizeBox = const SizedBox(height: 20);

    return Scaffold(
      appBar: AppBar(
          title: const Center(
            child: Text(
              "Home Page",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          leading: Builder(builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(
                Icons.menu,
                color: Colors.black,
              ),
            );
          })),
      body: const SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "\n \nWellcome to the Home Page. \n \n=> Click on the menu button to see your profile data \n \n=>Click on each item to update. \n \nNotice: This Application is under process",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final newPhotoURL =
                          await _showUpdateProfilePictureDialog();
                      if (newPhotoURL != null) {
                        setState(() {
                          photoURL = newPhotoURL;
                        });
                      }
                      // displayAlertWithFun(
                      //     headingText: "Update your Profile Photo",
                      //     hintText: "Image URL",
                      //     onPressed: updateProfileImage,
                      //     fieldcontroller: _updatePhotoURL);
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(photoURL ??
                          "https://e7.pngegg.com/pngimages/348/800/png-clipart-man-wearing-blue-shirt-illustration-computer-icons-avatar-user-login-avatar-blue-child.png"),
                      radius: 40,
                    ),
                  ),
                  customSizeBox,
                  InkWell(
                    onTap: () {
                      displayAlertWithFun(
                          fieldcontroller: _updateDisplayName,
                          headingText: "Update Display Name",
                          hintText: "Display Name",
                          onPressed: updateDisplayNameStore
                          // Navigator.pop(context);

                          );
                    },
                    child: Text(
                      userStoreData['name'] ?? "Display name not updated",
                      style: const TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            customSizeBox,
            ListTile(
              leading: const Icon(
                Icons.email,
                color: Colors.blue,
              ),
              title: Text(userEmailID ?? "Email ID not Set"),
              onTap: () {
                displayAlertWithFun(
                    headingText: "Update Email Address",
                    hintText: "New Email Address",
                    onPressed: updateEmailAddress,
                    fieldcontroller: _updateEmailAddress);
              },
            ),
            customSizeBox,
            ListTile(
              leading: Icon(
                isEmailVerified ? Icons.verified : Icons.block,
                color: isEmailVerified ? Colors.blue : Colors.red,
              ),
              onTap: sendVerificationRequest,
              title: Text(isEmailVerified
                  ? "Email Verified"
                  : "Click to Verify Email Address"),
            ),
            customSizeBox,
            ListTile(
                leading: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                title: Text("Delete The Account"),
                onTap: deleteAccoutFunction),
            customSizeBox,
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.blue,
              ),
              title: const Text("Sign Out"),
              onTap: () async {
                if (widget.user != null) {
                  if (isGoogleSignIn(widget.user!)) {
                    await GoogleSignOut();
                  }
                } else {
                  await FirebaseAuth.instance.signOut();
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>?> getDocumentData(String documentId) async {
    final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(documentId)
        .get();

    if (documentSnapshot.exists) {
      final Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      print(data);

      return data;
    } else {
      return null; // Document with the specified ID doesn't exist
    }
  }

  void updateDisplayNameStore() {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    users
        .doc(widget.user?.uid)
        .update({"name": _updateDisplayName.text}).then((_) {
      print("${_updateDisplayName.text} is updated successfully.");
      // Optionally, you can also update the state to reflect the new name
      setState(() {
        userProfileName = _updateDisplayName.text;
        Navigator.of(context).pop();
      });
    }).catchError((error) {
      print("Failed to update user: $error");
    });
  }

  void deleteAccoutFunction() async {
    final bool shouldDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
            'Are you sure you want to delete your account? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Yes'),
          ),
        ],
      ),
    );

    if (shouldDelete) {
      // Delete the user's data from Firestore.
      await deleteUser();

      if (await isFacebookLinked(widget.user!)) {
        deleteFacebookUserAccount();
      } else {
        // Delete the user's account from Firebase Auth.
        await FirebaseAuth.instance.currentUser!.delete();
        final FirebaseAuth _auth = FirebaseAuth.instance;
        await _auth.currentUser?.delete();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginPage()));
      }
    }
  }

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> deleteUser() {
    return users
        .doc(widget.user?.uid)
        .delete()
        .then((value) => print("User Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }

  // Function to check if the user is linked with Facebook.
  bool isFacebookLinked(User user) {
    for (UserInfo userInfo in user.providerData) {
      if (userInfo.providerId == 'facebook.com') {
        return true;
      }
    }
    return false;
  }

// Function to delete the user account linked with Facebook.
  Future<void> deleteFacebookUserAccount() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // User is not logged in.
      return;
    } else if (isFacebookLinked(user)) {
      try {
        // Delete the user's account.
        await user.delete();

        // Optionally, you can also unlink the Facebook provider:
        // await user.unlink('facebook.com');

        // Sign the user out after deleting the account.
        await FirebaseAuth.instance.signOut();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );

        // Handle successful deletion or other actions (e.g., navigate to a different screen).
        // ...
      } catch (e) {
        // Handle any errors that occur during the account deletion.
        print('Error deleting account: $e');
      }
    } else {
      // User is not linked with Facebook.
      // Handle this case as needed (e.g., show a message to the user).
      print('User is not linked with Facebook.');
    }
  }
}

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

bool isGoogleSignIn(User user) {
  for (UserInfo userInfo in user.providerData) {
    if (userInfo.providerId == 'google.com') {
      return true;
    }
  }
  return false;
}
