import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:snapverese/widgets/common.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String? email;
  const ResetPasswordScreen({super.key, this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final resetTokenController = TextEditingController(); 
  bool isLoading = false;
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    if (widget.email != null) {
      emailController.text = widget.email!;
    }
  }

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
              // Optional: allow pasting token, though not used in logic
              customTextField("Reset Token (optional)", resetTokenController),
              const Gap(20),
              customTextField("Email", emailController),
              const Gap(20),
              customTextField("New Password", passwordController),
              const Gap(20),
              customTextField("Confirm Password", confirmPasswordController),
              const Gap(50),
              ElevatedButton(onPressed:  isLoading
                    ? null
                    : () {
                        _handlePasswordReset();
                      }, child: Text("Reset Password"))
            ],
          ),
        ),
      ),
    );
  }


  Future<void> _handlePasswordReset() async {
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (password.isEmpty || confirmPassword.isEmpty) {
      _showAlert("Error", "All fields are required.");
      return;
    }

    if (password != confirmPassword) {
      _showAlert("Error", "Passwords do not match.");
      return;
    }

    setState(() => isLoading = true);

    try {
      await supabase.auth.updateUser(UserAttributes(password: password));

      if (mounted) {
        _showAlert("Success", "Password updated successfully. Please log in again.", onOk: () {
          Navigator.pop(context); // go back to login screen
        });
      }
    } catch (e) {
      _showAlert("Error", e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showAlert(String title, String message, {VoidCallback? onOk}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (onOk != null) onOk();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
