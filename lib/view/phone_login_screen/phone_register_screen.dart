import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:snapverese/controller/auth_controller.dart';
import 'package:snapverese/view/bottom_navigation_bar/bottom_nav_screen.dart';
import 'package:snapverese/widgets/common.dart';

class PhoneRegisterScreen extends StatefulWidget {
  final String phone;
  const PhoneRegisterScreen({super.key, required this.phone});

  @override
  State<PhoneRegisterScreen> createState() => _PhoneRegisterScreenState();
}

class _PhoneRegisterScreenState extends State<PhoneRegisterScreen> {
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              customText("Complete Registration", 32, fontWeight: FontWeight.bold),
              const Gap(50),
              customText("Enter your name", 16, fontWeight: FontWeight.w500, color: Colors.grey),
              const Gap(10),
              customTextField("John Smith", nameController),
              const Gap(30),
              customButton("Finish Registration", () async {
                final name = nameController.text.trim();

                if (name.isEmpty) {
                  showSnackBar(context, "Please enter your name");
                  return;
                }

                try {
                  await authController.registerPhoneUser(
                    name: name,
                    phone: widget.phone,
                  );

                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const BottomNavScreen()),
                      (route) => false,
                    );
                  }
                } catch (e) {
                  showSnackBar(context, "Registration failed: $e");
                }
              }, null),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}
