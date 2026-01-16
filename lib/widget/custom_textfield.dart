import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String text;
  final Widget icon;
  final TextInputType typeKey;

  const CustomTextfield({
    super.key,
    required this.controller,
    required this.text,
    required this.icon,
    this.typeKey = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: typeKey,
      decoration: InputDecoration(
        hintText: text,
        suffixIcon: icon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }
}
