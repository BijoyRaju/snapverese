import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:snapverese/controller/follow_controller.dart';
import 'package:snapverese/controller/post_controller.dart';
import 'package:snapverese/controller/user_controller.dart';
import 'package:snapverese/model/post_model.dart';
import 'package:snapverese/model/user_model.dart';
import 'package:snapverese/view/profile/post_details.dart';
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
  int followerCount = 0;
  int followingCount = 0;

  @override
  void initState() {
    fetchUserPosts();
    checkFollowStatus();
    fetchFollowerCount();
    super.initState();
  }



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
            title: customText("Profile", 24, fontWeight: FontWeight.w500, color: Colors.white),
            centerTitle: true,
            elevation: 4,
            foregroundColor: Colors.white,
            ),
          ),
        ),
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
            : Consumer<FollowController>(
                      builder: (context, followController, _) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            profileButton(
                            isFollowing ? "Unfollow" : "Follow",
                            () async {
                              final currentUser = Provider.of<UserController>(context, listen: false).currentUser;
                              if (currentUser == null) return;

                              setState(() => isFollowLoading = true);
                              final followController = Provider.of<FollowController>(context, listen: false);

                              if (isFollowing) {
                                await followController.unFollowUser(currentUser.uid, widget.user.uid);
                              } else {
                                await followController.followUser(currentUser.uid, widget.user.uid);
                              }

                              await fetchFollowerCount();
                              await checkFollowStatus(); 
                            },
                            isFollowing ? Colors.grey : Colors.black,
                          ),
                       ],
                   );
                },
              ),
            Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                customText("Posts  ${userPosts.length}", 20),
                Gap(20),
                customText("Follower  $followerCount", 20),
                Gap(20),
                customText("Following  $followingCount", 20)
              ],
            ),
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
                             showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                              ),
                              builder: (context) => PostDetails(
                                post: post,
                                isOwnProfile: widget.isOwnProfile,
                                onDelete: () async {
                                  final postController = PostController();
                                  await postController.deletePost(post.id); 
                                  fetchUserPosts();
                                  if(context.mounted){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Post deleted")),
                                  );
                                  }
                                },
                              ),
                            );
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
  setState(() {
    isFollowLoading = true;
  });

  final result = await followController.checkIfFollowing(currentUser.uid, widget.user.uid);

  log("Checking follow status: ${currentUser.uid} -> ${widget.user.uid}");

  setState(() {
    isFollowing = result;
    isFollowLoading = false;
  });
  log("Is following? $isFollowing");
}


  Future<void> fetchFollowerCount()async{
    final followController = Provider.of<FollowController>(context,listen: false);

    final followers = await followController.getFollowerCount(widget.user.uid);
    final following = await followController.getFollowingCount(widget.user.uid);
    setState(() {
      followerCount = followers;
      followingCount = following;
    });
  }
}