import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snapverese/controller/user_controller.dart';
import 'package:snapverese/view/profile/profile_screen.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserController>(
      builder: (context,userController,_){
        final currentUser = userController.currentUser;
        if(userController.isLoading || currentUser == null){
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }return ProfileScreen(user: currentUser,isOwnProfile: true);
      }
    );
  }
}