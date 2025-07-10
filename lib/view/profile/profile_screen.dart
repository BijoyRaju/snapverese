import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:snapverese/constants/shimmer.dart';
import 'package:snapverese/controller/follow_controller.dart';
import 'package:snapverese/controller/post_controller.dart';
import 'package:snapverese/controller/user_controller.dart';
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

  @override
  void initState() {
    super.initState();
    final postController = Provider.of<PostController>(context,listen: false);
    postController.fetchUserPost(widget.user.uid);
    final currentUser = Provider.of<UserController>(context,listen: false).currentUser;
    if(currentUser != null && !widget.isOwnProfile){
      final followController = Provider.of<FollowController>(context,listen: false);
      followController.checkIfFollowing(currentUser.uid, widget.user.uid);
      followController.getFollowerCount(widget.user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final postController = Provider.of<PostController>(context);
    final followController = Provider.of<FollowController>(context);
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
                    backgroundImage:  widget.user.profileImage != null && widget.user.profileImage!.isNotEmpty
                    ? NetworkImage(widget.user.profileImage!) as ImageProvider
                    : AssetImage('assets/images/profile.png')
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
            // Follow & Unfollow button
            if(!widget.isOwnProfile)
               followController.isLoading
                  ? const CircularProgressIndicator()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        profileButton(
                        followController.isFollowing ? "Unfollow" : "Follow",
                        () async {
                          final currentUser = Provider.of<UserController>(context, listen: false).currentUser;
                          if (currentUser == null) return;
                          if(followController.isFollowing){
                             await followController.unFollowUser(currentUser.uid,widget.user.uid);
                          }else{
                            await followController.followUser(currentUser.uid, widget.user.uid);
                          }
                          await followController.getFollowerCount(widget.user.uid);
                        },
                        followController.isFollowing ? Colors.grey : Colors.black,
                        )
                      ],
                ),
              const Gap(20),
              // Count of post,follower & following
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      customText("Posts  ${postController.userPost.length}", 20),
                      Gap(20),
                      customText("Follower  ${followController.isFollowerCount}", 20),
                      Gap(20),
                      customText("Following  ${followController.isFllowingCount}", 20)
                    ],
                  ),
              Divider(),
              // Posts by user
              postController.isLoading
              ? const SizedBox(height: 20)
              : Padding(
                    padding: const EdgeInsets.all(8),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: postController.userPost.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemBuilder: (context, index) {
                        final post = postController.userPost[index];
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
                                  await postController.deletePost(post.id,widget.user.uid);
                                  await postController.fetchUserPost(widget.user.uid); 
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
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Shimmer.fromColors(
                                baseColor: shimmerGradient.colors[0],
                                highlightColor: shimmerGradient.colors[1],
                                child: Container(
                                  height: 200,
                                  color: Colors.grey[300],
                                ),
                              );
                            },
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