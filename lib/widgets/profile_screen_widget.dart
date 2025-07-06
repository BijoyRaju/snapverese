import 'package:flutter/material.dart';

Widget profileButton(String title, VoidCallback onPressed,Color color) {
  return SizedBox(
    height: 40,
    width: 150,

    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
      child: Text(title, style: TextStyle(fontSize: 16)),
    ),
  );
}