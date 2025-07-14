import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:snapverese/controller/auth_controller.dart';
import 'package:snapverese/view/phone_login_screen/otp_verify_screen.dart';
import 'package:snapverese/widgets/common.dart';

class PhoneLoginScreen extends StatelessWidget {
  PhoneLoginScreen({super.key});

  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            children: [
              Center(child: customText("Phone Login", 40, fontWeight: FontWeight.bold)),
              const Gap(100),

              customText(
                "Phone Number",
                16,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(255, 92, 92, 92),
              ),
              const Gap(11),

              customTextField("9846284412", phoneController),
              const Gap(40),

              customButton("Send OTP", ()  async{
                final rawPhone = phoneController.text.trim();
                if(rawPhone.isEmpty) {
                  showSnackBar(context, "Please enter your phone number");
                  return;
                }

                if (!isValidPhone(rawPhone)) {
                  showSnackBar(context, "Enter a valid 10-digit phone number");
                  return;
                }

                final formattedPhone = "+91$rawPhone";

                try {
                  await authController.sendOtp(formattedPhone);

                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OtpVerifyScreen(phone: formattedPhone),
                      ),
                    );
                  } } catch (e) {
                    if(context.mounted){
                  showSnackBar(context, "Failed to send OTP: $e");
                    }
                }
              },null),
            ],
          ),
        ),
      ),
    );
  }

  bool isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^[6-9]\d{9}$');
    return phoneRegex.hasMatch(phone);
  }
}
