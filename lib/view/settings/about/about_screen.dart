import 'package:flutter/material.dart';
import 'package:snapverese/widgets/common.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
      title: customText("About", 24, fontWeight: FontWeight.w500, color: Colors.white),
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 4,
      ),
    ),
  ),
  body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: CircleAvatar(
                radius: 100,
                backgroundImage: AssetImage('assets/images/SNAPvERSE.png'),
              ),
            ),
            SizedBox(height: 16),

            Text(
              "SNAPvERSE",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),

            Text(
              "SNAPvERSE is a modern and minimal social media app where users can share moments, follow others, and explore a vibrant digital space.",
              style: TextStyle(fontSize: 16),
            ),

            SizedBox(height: 24),
            Divider(),

            Text("Key Features", style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 8),
            Text("• Google Sign-In\n• Post text & images\n• Follow/Unfriend users\n• View profiles & feeds"),

            SizedBox(height: 24),
            Divider(),

            Text("Developer", style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 8),
            Text("Bijoy Raju\nFlutter Developer", style: TextStyle(fontSize: 16)),

            SizedBox(height: 24),

            Text("Version", style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 8),
            Text("1.0.0"),

            SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                },
                icon: Icon(Icons.email),
                label: Text("Contact Developer"),
              ),
            )
          ],
        ),
      ),
    );
  }
}