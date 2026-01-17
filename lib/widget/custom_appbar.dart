import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String text;

  const CustomAppbar({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return AppBar(title: Text(text), centerTitle: true);
  }

  @override
  Size get preferredSize => Size.fromHeight(100);
}
