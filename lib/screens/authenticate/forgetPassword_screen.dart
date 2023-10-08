import 'package:flutter/material.dart';
import 'package:usermanagementapp/components/custom_elevatedButton.dart';
import 'package:usermanagementapp/components/custom_textfield.dart';
import 'package:usermanagementapp/models/forget_password.dart';
import 'package:usermanagementapp/screens/authenticate/login.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    void showSnackbar(String message) {
      final snackBar = SnackBar(
        duration: const Duration(seconds: 3),
        content: Text(message),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    final _email = TextEditingController();
    var customSizeBox = const SizedBox(height: 20);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forget Password"),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            customSizeBox,
            CustomTextField(controller: _email, hintText: "Email Address"),
            customSizeBox,
            const Text(
                "Password reset link will be sent to your registered email address, please check your email inbox."),
            customSizeBox,
            ElevatedButtonCusstom(
              buttonText: "Password Reset",
              onPressed: () async {
                if (_email.text.isNotEmpty) {
                  final isEmailSent =
                      await sendForgetPasswordEmail(_email.text);
                  if (isEmailSent) {
                    setState(() {
                      _email.clear();
                      showSnackbar(
                          "Password reset link has been sent to your registered email address");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()));
                    });
                  }
                }
              },
            )
          ],
        ),
      )),
    );
  }
}
