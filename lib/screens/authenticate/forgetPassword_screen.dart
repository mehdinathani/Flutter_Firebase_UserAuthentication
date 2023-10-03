import 'package:flutter/material.dart';
import 'package:usermanagementapp/components/custom_elevatedButton.dart';
import 'package:usermanagementapp/components/custom_textfield.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    final _email = TextEditingController();
    var customSizeBox = const SizedBox(height: 20);
    return Scaffold(
      appBar: AppBar(
        title: Text("Forget Password"),
      ),
      body: SafeArea(
          child: Column(
        children: [
          customSizeBox,
          CustomTextField(controller: _email, hintText: "Email Address"),
          customSizeBox,
          const Text(
              "Password reset link will be sent to your registered email address, please check your email inbox."),
          customSizeBox,
          const ElevatedButtonCusstom(buttonText: "Password Reset")
        ],
      )),
    );
  }
}
