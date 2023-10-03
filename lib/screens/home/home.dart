import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:usermanagementapp/screens/authenticate/login.dart';

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

  Future<bool?> checkEmailVerification() async {
    final emailVerified = await widget.user?.emailVerified;
    setState(() {
      isEmailVerified = true;
    });
  }

  loadUserProfileDate() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userProfileName = user.displayName;
        userEmailID = user.email;
        userMobileNumber = user.phoneNumber;
        photoURL = user.photoURL;
        checkEmailVerification();
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
    var customSizeBox = const SizedBox(height: 20);

    return Scaffold(
      appBar: AppBar(
          title: Text("Home Page"),
          leading: Builder(builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu),
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
              decoration: const BoxDecoration(color: Colors.blue),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      displayAlertWithFun(
                          headingText: "Update your Profile Photo",
                          hintText: "Image URL",
                          onPressed: updateProfileImage,
                          fieldcontroller: _updatePhotoURL);
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
                          onPressed: updateDisplayNameFunction);
                    },
                    child: Text(
                      userProfileName ?? "Display name not updated",
                      style: TextStyle(fontSize: 20),
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
              leading: const Icon(
                Icons.logout,
                color: Colors.blue,
              ),
              title: const Text("Sign Out"),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
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
}
