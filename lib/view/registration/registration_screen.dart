import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:snapverese/controller/auth_controller.dart';
import 'package:snapverese/view/home/home_screen.dart';
import 'package:snapverese/view/login_screen/login_screen.dart';
import 'package:snapverese/widgets/common.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    rePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: customText("REGISTER", 40, fontWeight: FontWeight.bold)),
                  const Gap(80),
                  customText("Enter your name", 16, fontWeight: FontWeight.w500, color: const Color.fromARGB(255, 92, 92, 92)),
                  const Gap(11),
                  customTextField("Jhon Smith", nameController),
                  const Gap(20),
                  customText("Enter your mobile number", 16, fontWeight: FontWeight.w500, color: const Color.fromARGB(255, 92, 92, 92)),
                  const Gap(11),
                  customTextField("9846284412", phoneController),
                  const Gap(20),
                  customText("Enter your email", 16, fontWeight: FontWeight.w500, color: const Color.fromARGB(255, 92, 92, 92)),
                  const Gap(11),
                  customTextField("xxx@gmail.com", emailController),
                  const Gap(11),
                  customText("Enter your password", 16, fontWeight: FontWeight.w500, color: const Color.fromARGB(255, 92, 92, 92)),
                  const Gap(11),
                  customTextField("**********", passwordController),
                  const Gap(11),
                  customText("Re-Enter your password", 16, fontWeight: FontWeight.w500, color: const Color.fromARGB(255, 92, 92, 92)),
                  const Gap(11),
                  customTextField("**********", rePasswordController),
                  const Gap(20),
                  customButton("Register", () async {
                    final name = nameController.text.trim();
                    final phone = phoneController.text.trim();
                    final email = emailController.text.trim();
                    final password = passwordController.text.trim();
                    final rePassword = rePasswordController.text.trim();

                    if (name.isEmpty || phone.isEmpty || email.isEmpty || password.isEmpty || rePassword.isEmpty) {
                      showSnackBar(context, "Please fill all fields");
                      return;
                    }

                    if (password != rePassword) {
                      showSnackBar(context, "Passwords do not match");
                      return;
                    }

                    final authController = Provider.of<AuthController>(context, listen: false);
                    try {
                      await authController.register(
                        name: name,
                        email: email,
                        phone: phone,
                        password: password,
                        profileImageUrl: '', 
                      );

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                      );
                    } catch (e) {
                      showSnackBar(context, "Registration failed: $e");
                    }
                  }, null),
                  const Gap(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      customText("Already have an account?", 16, fontWeight: FontWeight.w500, color: const Color.fromARGB(255, 92, 92, 92)),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                        },
                        child: customText(" Sign In", 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
