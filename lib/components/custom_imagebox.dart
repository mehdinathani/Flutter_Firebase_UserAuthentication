import 'package:flutter/material.dart';

class CustomImageBox extends StatelessWidget {
  final Function() onTap;
  final String imagePath;
  const CustomImageBox(
      {super.key, required this.imagePath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: media.width * 0.15,
        height: media.height * 0.15,
        child: Image.asset(imagePath),
      ),
    );
  }
}
