import 'package:flutter/material.dart';

Widget settingsCard(String text,IconData icon,VoidCallback onPressed){
  return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: Icon(icon, size: 28),
        title: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18),
        onTap: onPressed,
      ),
    );
}