import 'package:flutter/material.dart';

Widget profileButton(String title, VoidCallback onPressed) {
  return SizedBox(
    height: 40,
    width: 150,

    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        // padding: EdgeInsets.symmetric(vertical: 10,horizontal: 25),
      ),
      child: Text(title, style: TextStyle(fontSize: 16)),
    ),
  );
}