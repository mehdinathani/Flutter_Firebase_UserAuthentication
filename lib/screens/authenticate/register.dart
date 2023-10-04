import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:usermanagementapp/components/custom_elevatedButton.dart';
import 'package:usermanagementapp/components/custom_textfield.dart';
import 'package:usermanagementapp/screens/authenticate/login.dart';

class RegistrationView extends StatefulWidget {
  const RegistrationView({super.key});

  @override
  State<RegistrationView> createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView> {
  bool agreeToTerms = false;
  bool showLoader = false;
  String snackbarfiremsg = '';
  void showSnackbar(String message) {
    final snackBar = SnackBar(
      duration: const Duration(seconds: 3),
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  updateUserProfile(userid) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection("users");
    users.doc(userid).set({
      'uid': userid,
      'name': _name.text,
      'dateOfBirth': _dob.text,
      'gender': genderSelected,
      'mobile': _phoneNumber.text,
      'email': _email.text,
    }).then((value) {
      print("User Added");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
      showLoader = false;
    }).catchError((error) => print("Failed to add user: $error"));
  }

  registerUser() async {
    try {
      setState(() {
        showLoader = true;
      });
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email.text,
        password: _password.text,
      );
      updateUserProfile(credential.user?.uid);

      // Registration successful, show a congratulatory snackbar

      snackbarfiremsg =
          "Congratulations! Registration successful. \nPlease login with your email and password";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        snackbarfiremsg = 'weak-password';
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        snackbarfiremsg = 'The account already exists for that email.';
        print('The account already exists for that email.');
      }
    } catch (e) {
      snackbarfiremsg = e.toString();
      print(e);
    }
  }

  var genderSelected;
  var GenderTypes = ["Male", "Female", "Prefer not to Say"];

  bool _obscureText = true;
  var customSizeBox = const SizedBox(height: 20);
  final _email = TextEditingController();
  final _name = TextEditingController();
  final _phoneNumber = TextEditingController();
  final _dob = TextEditingController();
  final _gender = TextEditingController();
  final _password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
      controller: _email,
      autofocus: false,
      validator: (value) {
        if (value != null) {
          if (value.contains('@')) {
            return null;
          }
          return 'Enter a Valid email address.';
        }
        return null; // Valid email
      },
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email Address",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
    );

    final nameField = TextField(
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Name",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
      controller: _name,
    );

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
      appBar: AppBar(
        title: const Center(
          child: Text("User Registration"),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                nameField,
                const SizedBox(
                  height: 20,
                ),
                emailField,
                const SizedBox(
                  height: 20,
                ),
                passwordField,
                customSizeBox,
                CustomTextField(
                  keyboardType: TextInputType.phone,
                  controller: _phoneNumber,
                  hintText: "Mobile Number",
                ),
                customSizeBox,
                CustomTextField(
                  controller: _dob,
                  hintText: "Date of Birth",
                  keyboardType: TextInputType.datetime,
                ),
                customSizeBox,
                Container(
                  // color: Colors.amber,
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.07,
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.centerLeft,
                  child: DropdownButton<String>(
                    hint: const Text(
                      "Select Gender",
                      style: TextStyle(fontSize: 20),
                    ),
                    value: genderSelected,
                    isDense: true,
                    onChanged: (newValue) {
                      setState(() {
                        genderSelected = newValue;
                      });
                      print(genderSelected);
                    },
                    items: GenderTypes.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(fontSize: 17),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                customSizeBox,
                Row(
                  children: [
                    Checkbox(
                        value: agreeToTerms,
                        onChanged: (bool? newValue) {
                          if (newValue != null) {
                            setState(() {
                              agreeToTerms = newValue;
                            });
                          }
                        }),
                    const Text("I agree with all Terms and Condition.")
                  ],
                ),
                customSizeBox,
                ElevatedButtonCusstom(
                  buttonText: "Submit",
                  onPressed: () async {
                    // snackbarfiremsg = '';
                    if (_name.text.isEmpty ||
                        _email.text.isEmpty ||
                        _password.text.isEmpty ||
                        _phoneNumber.text.isEmpty ||
                        _dob.text.isEmpty ||
                        genderSelected == null ||
                        agreeToTerms == false) {
                      var snackBar = const SnackBar(
                        content: Text("Please filled all required fields."),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      setState(() {
                        showLoader = false;
                      });
                    } else {
                      //
                      await registerUser();
                      showSnackbar(snackbarfiremsg);
                      _name.clear();
                      _email.clear();
                      _password.clear();
                      _phoneNumber.clear();
                      _dob.clear();
                      const Duration(milliseconds: 300);
                      setState(() {
                        showLoader = false;
                      });
                    }
                  },
                ),
                customSizeBox,
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                  },
                  child: const Text("Already have a Account? Login here"),
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
        ),
      ),
    );
  }
}
