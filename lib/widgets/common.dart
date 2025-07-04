import 'package:flutter/material.dart';

Widget customText(
  String text,
  double fontSize, {
  Color color = Colors.black,
  FontWeight fontWeight = FontWeight.normal,
}) {
  return Text(
    text,
    style: TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
    ),
  );
}

Widget customTextField(String hintText,TextEditingController controller) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      hintText: hintText,
      labelStyle: TextStyle(color: Colors.grey),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.blue),
      ),
    ),
  );
}

Widget customButton(String title, VoidCallback onPressed, IconData? icon) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 14), 
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center, 
        children: [
          Text(title, style: TextStyle(fontSize: 16)),
          if (icon != null) ...[
            SizedBox(width: 5),
            Icon(icon),
          ],
        ],
      ),
    ),
  );
}


Widget loginCustomButton(String title, VoidCallback onPressed, String imagePath) {
  return SizedBox(
    width: double.infinity,
    child: TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        side: BorderSide(color: Colors.grey),
        foregroundColor: Colors.black,
        backgroundColor: Colors.transparent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, height: 20, width: 20),
          SizedBox(width: 10),
          Text(title,style: TextStyle(fontSize: 16),),
        ],
      ),
    ),
  );
}

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}

