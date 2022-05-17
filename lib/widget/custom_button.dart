import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double height;
  final double circularRadius;
  const CustomButton(
      {Key? key,
      required this.text,
      required this.onPressed,
      this.height = 55,
      this.circularRadius = 30})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 2,
      onPressed: onPressed,
      child: Container(
        height: height,
        decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(circularRadius)),
        child: Center(
            child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        )),
      ),
    );
  }
}
