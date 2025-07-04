import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:snapverese/controller/post_controller.dart';
import 'package:snapverese/model/post_model.dart';
import 'package:snapverese/model/user_model.dart';
import 'package:snapverese/service/user_service.dart';
import 'package:snapverese/view/home/screens/add_post_screen.dart';
import 'package:snapverese/view/home/screens/notification_dialog.dart';
import 'package:snapverese/widgets/common.dart';
import 'package:snapverese/widgets/home_screen_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    Future.microtask(() {
    Provider.of<PostController>(context, listen: false).loadPosts();
  });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: customText("SNAPvERSE", 24,fontWeight: FontWeight.w500),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddPostScreen()));
          }, icon: Icon(Icons.add),iconSize: 28),
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationDialog()));
          }, icon: Icon(Icons.notifications),iconSize: 28)
        ],
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Divider(),
          InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddPostScreen()),
        );
      },
      child: snapItShareItLikeIt(),
          ),
        Expanded(child: Consumer<PostController>(
              builder: (context, postController, _) {
                if (postController.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (postController.posts.isEmpty) {
                  return const Center(child: Text("No posts available"));
                }

                return ListView.builder(
                    itemCount: postController.posts.length,
                    itemBuilder: (context, index) {
                      final post = postController.posts[index]; // define post here

                      return FutureBuilder<UserModel?>(
                        future: UserService().getUserById(post.uid), // use post.uid
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          final user = snapshot.data;
                          final timeFormatted = DateFormat('hh:mm a').format(post.createdAt.toLocal());

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: postCard(
                              user?.name ?? "Unknown",
                              user?.profileImage,
                              post.imageUrl,
                              post.caption,
                              timeFormatted,
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              )
          )
        ],
      ),
    );
  }
}