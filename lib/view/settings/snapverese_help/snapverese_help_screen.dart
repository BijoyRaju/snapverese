import 'package:flutter/material.dart';
import 'package:snapverese/widgets/common.dart';

class SnapvereseHelpScreen extends StatelessWidget {
  const SnapvereseHelpScreen({super.key});

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
      title: customText("Help ", 24, fontWeight: FontWeight.w500, color: Colors.white),
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 4,
      ),
    ),
  ), 
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text("How to Use SNAPvERSE", style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 10),
          Text("• Sign in with Google to start using the app."),
          Text("• Create posts using the '+' button on the home screen."),
          Text("• Follow users by visiting their profile."),
          Text("• Tap a post to like or comment."),

          SizedBox(height: 24),
          Text("FAQs", style: Theme.of(context).textTheme.titleLarge),
          ExpansionTile(
            title: Text("How do I reset my password?"),
            children: [Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Go to Settings > Account > Reset Password."),
            )],
          ),
          ExpansionTile(
            title: Text("How can I delete my account?"),
            children: [Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Please contact support to request account deletion."),
            )],
          ),
          ExpansionTile(
            title: Text("Why can’t I see my posts?"),
            children: [Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Make sure you're connected to the internet and logged in."),
            )],
          ),

          SizedBox(height: 24),
          Text("Need more help?", style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () {
            },
            icon: Icon(Icons.email),
            label: Text("Contact Support"),
          ),
        ],
      ),
    );
  }
}