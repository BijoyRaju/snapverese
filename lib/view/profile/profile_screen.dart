import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:snapverese/model/user_model.dart';
import 'package:snapverese/widgets/common.dart';
import 'package:snapverese/widgets/profile_screen_widget.dart';

class ProfileScreen extends StatelessWidget {

  final UserModel user;

  const ProfileScreen({super.key, required this.user});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile"),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(user.profileImage ?? ''),
                  ),
                  Gap(20),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customText(user.name, 20),
                      customText(user.bio ?? '', 16),
                    ],
                  )),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                profileButton("Follow", (){}),
                Gap(20),
                profileButton("Unfollow", (){})

              ],
            ),
            
            Gap(20),
            Divider(),
            Padding(padding: EdgeInsets.all(8),
            // child: GridView.builder(
            //   physics: NeverScrollableScrollPhysics(),
            //   shrinkWrap: true,
            //   itemCount: ,
            //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //     crossAxisCount: crossAxisCount
            //     crossAxisSpacing: ,
            //     mainAxisExtent: 
            //   ),
            //   itemBuilder: itemBuilder
            // ),
            )
          ],
        ),
      ),
    );
  }
}