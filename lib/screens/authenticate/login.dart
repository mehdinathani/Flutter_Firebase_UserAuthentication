import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:usermanagementapp/components/custom_elevatedButton.dart';
import 'package:usermanagementapp/components/custom_textfield.dart';
import 'package:usermanagementapp/screens/authenticate/forgetPassword_screen.dart';
import 'package:usermanagementapp/screens/authenticate/login_With_Twitter.dart';
import 'package:usermanagementapp/screens/authenticate/login_with_facebook.dart';
import 'package:usermanagementapp/screens/authenticate/login_with_github.dart';
import 'package:usermanagementapp/screens/authenticate/login_with_google.dart';
import 'package:usermanagementapp/screens/authenticate/register.dart';
import 'package:usermanagementapp/screens/home/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String customSnackBarMSG = '';
  void showSnackbar(String message) {
    final snackBar = SnackBar(
      duration: const Duration(seconds: 3),
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  loginUserWithEmail() async {
    try {
      setState(() {
        showLoader = true;
      });
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email.text,
        password: _password.text,
      );
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        print(user.displayName);
        print(user.email);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(
                      user: user,
                    )));
      }
      customSnackBarMSG = "Login Successfull";
      setState(() {
        showLoader = false;
      });
    } on FirebaseAuthException catch (e) {
      showLoader = true;
      if (e.code == 'user-not-found') {
        customSnackBarMSG = 'No user found for that email.';
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        customSnackBarMSG = 'Wrong password provided for that user.';
        print('Wrong password provided for that user.');
      } else {
        customSnackBarMSG = e.code.toString();
      }
    }
    setState(() {
      showLoader = false;
    });
  }

  //declarations
  bool _obscureText = true;
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool rememberme = false;
  bool showLoader = false;
  @override
  Widget build(BuildContext context) {
    var customSizeBox = const SizedBox(height: 20);

    //password field

    final passwordField = TextFormField(
        obscureText: _obscureText,
        controller: _password,
        autofocus: false,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'This field is required';
          }
          if (value.trim().length < 8) {
            return 'Password must be at least 8 characters in length';
          }
          // Return null if the entered password is valid
          return null; // Valid password
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Password",
            suffixIcon: IconButton(
              icon:
                  Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              customSizeBox,
              CustomTextField(controller: _email, hintText: "Email address"),
              customSizeBox,
              passwordField,
              customSizeBox,
              Row(
                children: [
                  Checkbox(
                      value: rememberme,
                      onChanged: (bool? newValue) {
                        if (newValue != null) {
                          setState(() {
                            rememberme = newValue;
                          });
                        }
                      }),
                  const Text("Remember me.")
                ],
              ),
              customSizeBox,
              ElevatedButtonCusstom(
                buttonText: "Login",
                onPressed: () async {
                  if (_email.text.isEmpty || _password.text.isEmpty) {
                    customSnackBarMSG = "All Fields are Required.";
                    setState(() {
                      showSnackbar(customSnackBarMSG);
                    });
                  } else {
                    await loginUserWithEmail();
                    setState(() {
                      showSnackbar(customSnackBarMSG);
                    });
                  }
                },
              ),
              customSizeBox,
              ElevatedButtonCusstom(
                buttonText: "Sign in With Google",
                onPressed: () async {
                  setState(() {
                    showLoader = true;
                  });
                  await loginWithGoogle();
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    if (kDebugMode) {
                      print(user.displayName);
                      print(user.email);
                    }
                    await updateUserProfilefromGoogle(user);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomePage(
                                  user: user,
                                )));
                  }
                  customSnackBarMSG = "Login Successfull";
                  setState(() {
                    showLoader = false;
                  });
                },
              ),
              customSizeBox,
              ElevatedButtonCusstom(
                buttonText: "Sign in With Facebook",
                onPressed: () async {
                  setState(() {
                    showLoader = true;
                  });
                  await loginWithFB();
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    if (kDebugMode) {
                      print(user.displayName);
                      print(user.email);
                    }
                    await updateUserProfilefromFB(user);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomePage(
                                  user: user,
                                )));
                  }
                  customSnackBarMSG = "Login Successfull";
                  setState(() {
                    showLoader = false;
                  });
                },
              ),
              customSizeBox,
              ElevatedButtonCusstom(
                buttonText: "Sign in With Twitter",
                onPressed: () async {
                  setState(() {
                    showLoader = true;
                  });
                  await loginWithTwitter();
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    if (kDebugMode) {
                      print(user.displayName);
                      print(user.email);
                    }
                    await updateUserProfilefromTwitter(user);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomePage(
                                  user: user,
                                )));
                  }
                  customSnackBarMSG = "Login Successfull";
                  setState(() {
                    showLoader = false;
                  });
                },
              ),
              customSizeBox,
              ElevatedButtonCusstom(
                buttonText: "Sign in With Github",
                onPressed: () async {
                  setState(() {
                    showLoader = true;
                  });
                  await loginWithGithub(context);
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    if (kDebugMode) {
                      print(user.displayName);
                      print(user.email);
                    }
                    await updateUserProfilefromGithub(user);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomePage(
                                  user: user,
                                )));
                  }
                  customSnackBarMSG = "Login Successfull";
                  setState(() {
                    showLoader = false;
                  });
                },
              ),
              customSizeBox,
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgetPasswordScreen()));
                },
                child: const Text("Forget Password"),
              ),
              customSizeBox,
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegistrationView()));
                },
                child: const Text("Don't have a Account? Register here."),
              ),
              customSizeBox,
              Visibility(
                visible: showLoader,
                child: CircularProgressIndicator(
                  color: Colors.blue.shade900,
                  backgroundColor: Colors.black,
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
