import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:snapverese/controller/auth_controller.dart';
import 'package:snapverese/service/auth_services.dart';
import 'package:snapverese/view/bottom_navigation_bar/bottom_nav_screen.dart';
import 'package:snapverese/view/phone_login_screen/phone_login_screen.dart';
import 'package:snapverese/view/registration/registration_screen.dart';
import 'package:snapverese/widgets/common.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {

@override
  void initState() {
    super.initState();
    AuthService.configDeepLink(context);
  }

  @override
  Widget build(BuildContext context) {

  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: customText("LOGIN", 40,fontWeight: FontWeight.bold)),
                  Gap(100),
                  customText("User Email", 16,fontWeight: FontWeight.w500,color: const Color.fromARGB(255, 92, 92, 92)),
                  Gap(11),
                  customTextField("xxx@gmail.com",userNameController),
                  Gap(20),
                  customText("Password", 16,fontWeight: FontWeight.w500,color: const Color.fromARGB(255, 92, 92, 92)),
                  Gap(11),
                  customTextField("*********",passwordController),
                  Gap(11),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: ()async{
                          AuthService.requestResetPassword();
                        },
                        child: customText("forgot password ?", 16,fontWeight: FontWeight.w500,color: const Color.fromARGB(255, 92, 92, 92))),
                    ],
                  ),
                  Gap(20),
                  customButton("Login", () async {
                    final email = userNameController.text.trim();
                    final password = passwordController.text.trim();

                    if (email.isEmpty || password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please enter email and password")),
                      );
                      return;
                    }

                    final authController = Provider.of<AuthController>(context, listen: false);

                    try {
                      await authController.login(email, password);
                      if(context.mounted){
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) =>  BottomNavScreen()),
                      );
                      }
                    } catch (e) {
                      if(context.mounted){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Login failed: $e")),
                      );
                      }
                    }
                  }, null),
                  Gap(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        customText("Don't have an account?", 16,fontWeight: FontWeight.w500,color: const Color.fromARGB(255, 92, 92, 92)),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationScreen()));
                          },
                          child: customText(" Sign Up", 16,fontWeight: FontWeight.bold)),
                      ],
                    ),
                  Gap(50),
                  loginCustomButton("Google", ()async{
                    final result = await AuthService().nativeGoogleSignIn();
                  if (result == "Google Authentication successful") {
                    if(context.mounted){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BottomNavScreen()));
                  }
                  }
                  }, 'assets/images/google.png'),
                  Gap(20),
                  loginCustomButton("Phone", (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PhoneLoginScreen()));
                  }, 'assets/images/phone.png')


                  // loginCustomButton("Apple", (){}, 'assets/images/apple.png'),
                ],
              ),
          ),
        ],
      ),
    );
  }
}