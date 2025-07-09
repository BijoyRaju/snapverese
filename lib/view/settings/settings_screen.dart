import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:snapverese/controller/auth_controller.dart';
import 'package:snapverese/view/login_screen/login_screen.dart';
import 'package:snapverese/view/settings/about/about_screen.dart';
import 'package:snapverese/view/settings/account_and_privacy/account_and_privacy_screen.dart';
import 'package:snapverese/view/settings/edit_profile/edit_profile_screen.dart';
import 'package:snapverese/view/settings/language/language_screen.dart';
import 'package:snapverese/view/settings/snapverese_help/snapverese_help_screen.dart';
import 'package:snapverese/widgets/common.dart';
import 'package:snapverese/widgets/settings_screen_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
  preferredSize: Size.fromHeight(70),
  child: ClipRRect(
    borderRadius: BorderRadius.vertical(
      bottom: Radius.circular(24), 
    ),
    child: AppBar(
      backgroundColor: Colors.black, 
      title: customText("Settings", 24, fontWeight: FontWeight.w500, color: Colors.white),
      automaticallyImplyLeading: false,
      centerTitle: true,
      elevation: 4,
      ),
    ),
  ),
    body: ListView(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  children: [
    settingsCard("Profile", Icons.edit,(){
      Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen()));
    }),
    // Language
    settingsCard("Language", Icons.language,(){
      Navigator.push(context, MaterialPageRoute(builder: (context) => LanguageScreen()));
    }),
    // settingsCard("Friends", Icons.co_present_outlined,(){}),
    Gap(15),
    customText("Preferences", 24,fontWeight: FontWeight.w700),
    Gap(15),

    // Account & Privacy
    settingsCard("Account & Privacy", Icons.privacy_tip_rounded,(){
      Navigator.push(context, MaterialPageRoute(builder: (context) => AccountAndPrivacyScreen()));
    }),

    // Help
    settingsCard("SNAPvERESE Help", Icons.help_outline,(){
      Navigator.push(context, MaterialPageRoute(builder: (context) => SnapvereseHelpScreen()));
    }),

    // About
    settingsCard("About", Icons.info_outline,(){
      Navigator.push(context, MaterialPageRoute(builder: (context) => AboutScreen()));
    }),

    Gap(15),
    customButton("Log Out", ()async{
      final authController = Provider.of<AuthController>(context,listen: false);
      await authController.signOut();
      if(context.mounted){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Logout Successfull")));
      }
    }, null)
  ],
),
    );
  }
  
}