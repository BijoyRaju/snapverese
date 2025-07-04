import 'package:flutter/material.dart';
import 'package:snapverese/widgets/common.dart';

class AccountAndPrivacyScreen extends StatelessWidget {
  const AccountAndPrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(24), 
          ),
          child: AppBar(
            backgroundColor: Colors.black, 
            title: customText("Account & Privacy", 24, fontWeight: FontWeight.w500, color: Colors.white),
            foregroundColor: Colors.white,
            centerTitle: true,
            elevation: 4,
            ),
          ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(
            "Your Privacy Matters",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: 16),
          Text(
              "• Your profile is currently **Public**. Anyone on SNAPvERSE can see your posts, followers, and likes. You can change this in settings."),
          SizedBox(height: 12),
          Text(
              "• We only collect basic information from your Google account: name, email, and profile photo."),
          SizedBox(height: 12),
          Text(
              "• Uploaded media (images/posts) are securely stored in cloud storage (Supabase). Only you or those who follow you (if private) can view them."),
          SizedBox(height: 12),
          Text(
              "• We do not share your personal data with third parties."),
          SizedBox(height: 12),
          Text(
              "• You may delete your account anytime from Settings. This will remove all your data permanently."),
          SizedBox(height: 12),
          Divider(),
          Text("For any privacy concerns or support, contact us at:"),
          Text("📧 support@snapverse.app", style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
