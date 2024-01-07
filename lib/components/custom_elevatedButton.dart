import 'package:flutter/material.dart';

class ElevatedButtonCusstom extends StatelessWidget {
  final Function()? onPressed;
  final String buttonText;

  const ElevatedButtonCusstom(
      {super.key, this.onPressed, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.height * 0.07,
        child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.white),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: const BorderSide(color: Colors.black)))),
            onPressed: onPressed,
            child: Text(
              buttonText,
              style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            )));
  }
}
