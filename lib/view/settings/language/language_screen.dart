import 'package:flutter/material.dart';
import 'package:snapverese/widgets/common.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(24), 
          ),
          child: AppBar(
            backgroundColor: Colors.black, 
            title: customText("Language", 24, fontWeight: FontWeight.w500, color: Colors.white),
            foregroundColor: Colors.white,
            centerTitle: true,
            elevation: 4,
            ),
          ),
        ),
    );
  }
}