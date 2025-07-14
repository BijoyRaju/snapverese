import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:snapverese/controller/auth_controller.dart';
import 'package:snapverese/view/bottom_navigation_bar/bottom_nav_screen.dart';
import 'package:snapverese/view/phone_login_screen/phone_register_screen.dart';
import 'package:snapverese/widgets/common.dart';

class OtpVerifyScreen extends StatelessWidget {
  final String phone;
  final TextEditingController otpController = TextEditingController();

  OtpVerifyScreen({super.key, required this.phone});

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText("Verify OTP", 40),
                const Gap(100),
                customText(
                  "Enter OTP",
                  16,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromARGB(255, 92, 92, 92),
                ),
                const Gap(11),
                customTextField("Enter the OTP", otpController),
                const Gap(40),
                customButton("Verify", () async{
                  final otp = otpController.text.trim();

                  if (otp.isEmpty) {
                    showSnackBar(context, "Please enter the OTP");
                    return;
                  }

                  try {
                    final res = await authController.verifyPhoneOtp(phone, otp);

                    if (res.user != null) {
                      final isRegistered = await authController.checkIfRegistered();

                      if (!isRegistered) {
                        // 👇 User is not in `users` table — ask for name to complete registration
                        if (context.mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PhoneRegisterScreen(phone: phone),
                            ),
                          );
                        }
                      } else {
                        if (context.mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const BottomNavScreen()),
                          );
                        }
                      }
                    }
                  } catch (e) {
                    showSnackBar(context, "OTP verification failed: $e");
                  }
                }, null),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
