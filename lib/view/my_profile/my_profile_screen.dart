import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snapverese/controller/user_controller.dart';
import 'package:snapverese/view/profile/profile_screen.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context);
    final  currentUser = userController.currentUser;

    if(currentUser == null){
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return ProfileScreen(user: currentUser,isOwnProfile: true);
  }
}