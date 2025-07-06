import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:snapverese/controller/follow_controller.dart';
import 'package:snapverese/controller/post_controller.dart';
import 'package:snapverese/controller/user_controller.dart';
import 'package:snapverese/model/post_model.dart';
import 'package:snapverese/model/user_model.dart';
import 'package:snapverese/widgets/common.dart';
import 'package:snapverese/widgets/profile_screen_widget.dart';

class ProfileScreen extends StatefulWidget {

  final UserModel user;
  final bool isOwnProfile;

  const ProfileScreen({
    super.key,
    required this.user,
    this.isOwnProfile = false
    });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<PostModel> userPosts = [];
  bool isLoading = true;
  bool isFollowing = false;
  bool isFollowLoading = false;

  @override
  void initState() {
    fetchUserPosts();
    checkFollowStatus();
    super.initState();
  }

  Future<void> fetchUserPosts()async{
    final controller = PostController();
    final post = await controller.getUserPost(widget.user.uid);
    setState(() {
      userPosts = post;
      isLoading = false;
    });
  }

Future<void> checkFollowStatus() async {
  final followController = Provider.of<FollowController>(context, listen: false);
  final currentUser = Provider.of<UserController>(context, listen: false).currentUser;
  if (currentUser == null) {
    log("Current user is null");
    return;
  }
  log("Checking follow status: ${currentUser.uid} -> ${widget.user.uid}");

  setState(() => isFollowLoading = true);
  await followController.checkIfFollowing(currentUser.uid, widget.user.uid);
  setState(() {
    isFollowing = followController.isFollowing;
    isFollowLoading = false;
  });

  log("Is following? $isFollowing");
}

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
                    backgroundImage: NetworkImage(widget.user.profileImage ?? ''),
                  ),
                  Gap(20),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customText(widget.user.name, 20),
                      customText(widget.user.bio ?? '', 16),
                    ],
                  )),
                ],
              ),
            ),
            if(!widget.isOwnProfile)
            isFollowLoading
            ? CircularProgressIndicator()
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  profileButton("Follow", () async {
                    final currentUser = Provider.of<UserController>(context, listen: false).currentUser;
                    if (currentUser == null) {
                      log("Current user is null on Follow");
                      return;
                    }

                    log("Following user: ${currentUser.uid} -> ${widget.user.uid}");

                    setState(() => isFollowLoading = true);
                    await Provider.of<FollowController>(context, listen: false)
                        .followUser(currentUser.uid, widget.user.uid);

                    setState(() {
                      isFollowing = true;
                      isFollowLoading = false;
                    });

                    log("Followed successfully");
                  }, isFollowing ? Colors.grey : Colors.black),
                  Gap(20),
                  profileButton("Unfollow", () async {
                    final currentUser = Provider.of<UserController>(context, listen: false).currentUser;
                    if (currentUser == null) {
                      log("Current user is null on Unfollow");
                      return;
                    }

                    log("Unfollowing user: ${currentUser.uid} -> ${widget.user.uid}");

                    setState(() => isFollowLoading = true);
                    await Provider.of<FollowController>(context, listen: false)
                        .unFollowUser(currentUser.uid, widget.user.uid);

                    setState(() {
                      isFollowing = false;
                      isFollowLoading = false;
                    });

                    log("Unfollowed successfully");
                  }, !isFollowing ? Colors.grey : Colors.black),
                ],
              ),
            Gap(20),
            customText("Posts  ${userPosts.length}", 20),
            Divider(),
            Padding(
                    padding: const EdgeInsets.all(8),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: userPosts.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemBuilder: (context, index) {
                        final post = userPosts[index];
                        return GestureDetector(
                          onTap: () {
                          },
                          child: Image.network(
                            post.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}