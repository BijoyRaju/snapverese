import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:snapverese/view/forget_password/reset_password_screen.dart';
import 'package:snapverese/widgets/common.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final emailController = TextEditingController();
  bool isLoading = false;
  final supabase = Supabase.instance.client;

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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                customTextField("Email", emailController),
                const Gap(100),
                ElevatedButton(onPressed: isLoading ? null : _requestResetToken, child: Text("Send Reset Token")),
                const Gap(20),
                customText(
                  "You will receive a reset token in your email. Use it to reset your password.",
                  16,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _requestResetToken() async {
    setState(() => isLoading = true);

    try {
      await supabase.auth.resetPasswordForEmail(emailController.text.trim());

      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Check your email"),
            content: const Text("A reset password link has been sent to your email."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResetPasswordScreen(
                        email: emailController.text.trim(),
                      ),
                    ),
                  );
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Error"),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    } finally {
      setState(() => isLoading = false);
    }
  }
}