import 'package:flutter/material.dart';
import 'package:snapverese/widgets/common.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(24), 
          ),
          child: AppBar(
            backgroundColor: Colors.black, 
            title: customText("Notifications", 24, fontWeight: FontWeight.w500, color: Colors.white),
            automaticallyImplyLeading: false,
            centerTitle: true,
            elevation: 4,
            ),
          ),
        ),
    );
  }
}