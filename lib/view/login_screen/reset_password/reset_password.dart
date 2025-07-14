import 'package:flutter/material.dart';
import 'package:snapverese/service/auth_services.dart';
import 'package:snapverese/widgets/common.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController resetPassword = TextEditingController();
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reset Password"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              customTextField("Password", resetPassword),
              ElevatedButton(onPressed: ()async{
                AuthService.resetPassword(resetPassword.text);
              }, child: Text("New Password"))
            ],
          ),
        ),
      ),
    );
  }
}