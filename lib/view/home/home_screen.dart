import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:snapverese/controller/post_controller.dart';
import 'package:snapverese/controller/like_controller.dart';
import 'package:snapverese/controller/user_controller.dart';
import 'package:snapverese/model/user_model.dart';
import 'package:snapverese/view/home/screens/add_post_screen.dart';
import 'package:snapverese/widgets/common.dart';
import 'package:snapverese/widgets/home_screen_widget.dart';
import 'package:snapverese/service/user_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isInitialized = false;

 

  @override
  Widget build(BuildContext context) {
    return Consumer<UserController>(
      builder: (context, userController, _) {
        final currentUser = userController.currentUser;

        if (userController.isLoading || currentUser == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: customText("SNAPvERSE", 24, fontWeight: FontWeight.w500),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.add, size: 28),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AddPostScreen()));
                },
              ),
              // IconButton(
              //   icon: const Icon(Icons.notifications, size: 28),
              //   onPressed: () {
              //     Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationDialog()));
              //   },
              // ),
            ],
          ),
          body: Column(
            children: [
              const Divider(),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AddPostScreen()));
                },
                child: snapItShareItLikeIt(),
              ),
              Expanded(
                child: Consumer2<PostController, LikeController>(
                  builder: (context, postController, likeController, _) {
                    if (postController.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (postController.posts.isEmpty) {
                      return const Center(child: Text("No posts available"));
                    }

                    return ListView.builder(
                      itemCount: postController.posts.length,
                      itemBuilder: (context, index) {
                        final post = postController.posts[index];
                        final userId = currentUser.uid;


                        return FutureBuilder<UserModel?>(
                          future: UserService().getUserById(post.uid),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const SizedBox(height: 150);
                            }

                            final user = snapshot.data!;
                            final timeFormatted = DateFormat('hh:mm a').format(post.createdAt.toLocal());
                            final isLiked = likeController.isLikedByUser(post.id, userId);
                            final likes = likeController.likesCount[post.id]?.toString() ?? "0";

                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: postCard(
                                userName: user.name,
                                userImage: user.profileImage,
                                postImage: post.imageUrl,
                                caption: post.caption,
                                timeAgo: timeFormatted,
                                likeCount: likes,
                                likeFn: () => likeController.toggleLike(post.id, userId),
                                isLiked: isLiked,
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
   @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      _isInitialized = true;

      WidgetsBinding.instance.addPostFrameCallback((_)async{
      final userController = Provider.of<UserController>(context, listen: false);
      final postController = Provider.of<PostController>(context, listen: false);
      final likeController = Provider.of<LikeController>(context, listen: false);
      
      await userController.fetchCurrentUser();
        final userId = userController.currentUser?.uid;
        if (userId != null) {
          await postController.loadPosts();
            for (final post in postController.posts) {
              await likeController.fetchLikesData(post.id, userId);
            }
          }
      });
    }
  }
}
